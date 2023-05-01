//
//  SchemeDataService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 19.04.2023.
//

import Foundation
import Combine

class SchemeDataService{
    @Published var scheme: RestaurantScheme? = nil
    
    let token = AuthService.shared.getToken().trimmingCharacters(in: .whitespacesAndNewlines)
    static let instance = SchemeDataService()
    private init() { }
    
    var schemeSubscription: AnyCancellable?
    
    func fetchRestaurantScheme(for restaurantId: String){
        let urlString = Constants.BASE_URL + "/\(restaurantId)" + Constants.RESTAURANT_SCHEME
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        schemeSubscription = NetworkingManager.download(request: request)
            .decode(type: RestaurantScheme.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedScheme in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    self?.scheme = fetchedScheme
                    self?.schemeSubscription?.cancel()
                }
            }
    }
}
