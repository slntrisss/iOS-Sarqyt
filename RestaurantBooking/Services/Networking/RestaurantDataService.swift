//
//  RestaurantDataService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 03.04.2023.
//

import Combine
import Foundation

class RestaurantDataService{
    
    @Published var allRestaurants: [Restaurant] = []
    
    static let shared = RestaurantDataService()
    var cancellabels = Set<AnyCancellable>()
    
    private init(){ }
    
    func getAllRestaurants(){
        guard let url = URL(string: "http://localhost:3000/allRestaurants") else {return}

        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            URLSession.shared.dataTaskPublisher(for: url)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap { (data, response) -> Data in
                    guard
                        let response = response as? HTTPURLResponse,
                        response.statusCode >= 200 && response.statusCode < 300 else{
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .decode(type: [Restaurant].self, decoder: JSONDecoder())
                .sink { (completion) in
                    print("Completion: \(completion)")
                } receiveValue: { [weak self] restaurants in
                    self?.allRestaurants = restaurants
                    print(restaurants.count)
                }
                .store(in: &self.cancellabels)
        }
    }
}
