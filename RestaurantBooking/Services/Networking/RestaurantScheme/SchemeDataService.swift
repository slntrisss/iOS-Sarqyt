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
    
    static let instance = SchemeDataService()
    private init() { }
    
    var schemeSubscription: AnyCancellable?
    
    func fetchRestaurantScheme(for restaurantId: String){
        let urlString = Constants.BASE_URL + "/\(restaurantId)" + Constants.RESTAURANT_SCHEME
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        print(url.description)
        schemeSubscription = NetworkingManager.download(url: url)
            .decode(type: RestaurantScheme.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedScheme in
                self?.scheme = fetchedScheme
                self?.schemeSubscription?.cancel()
            }
    }
}
