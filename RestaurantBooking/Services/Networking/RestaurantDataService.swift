//
//  RestaurantDataService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 03.04.2023.
//

import Combine
import Foundation

class RestaurantDataService{
    
    @Published var recommendedRestaurants: [Restaurant] = []
    @Published var promotedRestaurants: [Restaurant] = []
    @Published var restaurantList: [Restaurant] = []
    var cancellables = Set<AnyCancellable>()
    
    static let instance = RestaurantDataService()
    
    private init(){ }
    
    func getAllRestaurants(){
        getRecommendedPreviewRestaurants()
        getPromotedRestaurants()
        getRestaurants()
    }
    
    private func getRecommendedPreviewRestaurants(){
        guard let url = URL(string: Constants.BASE_URL + Constants.RECOMMENDATIONS_PREVIEW) else {
            print("BAD URL: \(Constants.BASE_URL)\(Constants.RECOMMENDATIONS_PREVIEW)")
            return
        }
        
        NetworkingManager.download(url: url)
            .decode(type: [Restaurant].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] restaurants in
                self?.recommendedRestaurants = restaurants
            })
            .store(in: &cancellables)

    }
    
    private func getPromotedRestaurants(){
        guard let url = URL(string: Constants.BASE_URL + Constants.PROMOTIONS_PREVIEW) else {
            print("BAD URL: \(Constants.BASE_URL)\(Constants.PROMOTIONS_PREVIEW)")
            return
        }
        
        NetworkingManager.download(url: url)
            .decode(type: [Restaurant].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] restaurants in
                self?.promotedRestaurants = restaurants
            })
            .store(in: &cancellables)
    }
    
    private func getRestaurants(){
        guard let url = URL(string: Constants.BASE_URL + Constants.ALL_RESTAURANTS) else {
            print("BAD URL: \(Constants.BASE_URL)\(Constants.ALL_RESTAURANTS)")
            return
        }
        
        NetworkingManager.download(url: url)
            .decode(type: [Restaurant].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] restaurants in
                self?.restaurantList = restaurants
            })
            .store(in: &cancellables)
    }
}
