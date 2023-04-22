//
//  PaymentViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 02.04.2023.
//

import Foundation
import Combine

class PaymentViewModel: ObservableObject{
    @Published var paymentCards: [PaymentCard] = []
    
    @Published var addNewPaymentCard = false
    
    let dataService = PaymentCardDataService.instance
    var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    
    
    
    func getFormattedCardNumber(cardNumber: String) -> String{
        let chars = Array(cardNumber)
        var lastFourNumbers = ""
        var index = 4
        while(index > 0){
            lastFourNumbers += String(chars[cardNumber.count - index])
            index -= 1
        }
        return "•••• •••• •••• " + lastFourNumbers
    }
    
    func changeDefaultPaymentCard(card: PaymentCard){
        if let oldDefaultCardIndex = paymentCards.firstIndex(where: {$0.inUse}){
            paymentCards[oldDefaultCardIndex].inUse = false
        }
        if let newDefaultCardIndex = paymentCards.firstIndex(where: {$0.id == card.id}){
            paymentCards[newDefaultCardIndex].inUse = true
            dataService.changeDefaultPaymentCard(card: paymentCards[newDefaultCardIndex])
        }
    }
    
    func delete(at offsets: IndexSet){
        offsets.forEach { index in
            dataService.deletePaymentCard(card: paymentCards[index])
        }
        paymentCards.remove(atOffsets: offsets)
    }
    
    //MARK: - Networking
    private func addSubscribers(){
        dataService.$paymentCards
            .sink { [weak self] fetchedCards in
                self?.paymentCards = fetchedCards
            }
            .store(in: &cancellables)
        dataService.$paymentCard
            .sink { [weak self] fetchedCard in
                if let fetchedCard = fetchedCard{
                    self?.paymentCards.append(fetchedCard)
                }
            }
            .store(in: &cancellables)
    }
    
    func getCards(){
        dataService.getPaymentCards()
    }
}
