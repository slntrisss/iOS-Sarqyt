//
//  PaymentCardDataService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 22.04.2023.
//

import Foundation
import Combine

class PaymentCardDataService{
    @Published var paymentCards: [PaymentCard] = []
    @Published var paymentCard: PaymentCard? = nil
    
    var cardsSubscription: AnyCancellable?
    var cardSubscription: AnyCancellable?
    
    let authService = AuthService.shared
    
    static let instance = PaymentCardDataService()
    private init(){ }
    
    func getPaymentCards(){
        let urlString = Constants.BASE_URL + Constants.PAYMENT_CARDS
        let token = authService.getToken().trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        cardsSubscription = NetworkingManager.download(request: request)
            .decode(type: [PaymentCard].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedCards in
                self?.paymentCards = fetchedCards
                self?.cardsSubscription?.cancel()
            }
    }
    
    func changeDefaultPaymentCard(card: PaymentCard){
        let urlString = Constants.BASE_URL + Constants.PAYMENT_CARDS + "/\(card.id)"
        let token = authService.getToken().trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONEncoder().encode(card)
            request.httpBody = jsonData
            
            cardSubscription = NetworkingManager.post(request: request)
                .decode(type: PaymentCard.self, decoder: JSONDecoder())
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] updatedCard in
                    self?.paymentCard = updatedCard
                    self?.cardSubscription?.cancel()
                }
        } catch let error {
            print("Error occured: \(error.localizedDescription)")
        }
    }
}
