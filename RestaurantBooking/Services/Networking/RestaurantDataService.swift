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
        getRestaurantList(offset: 1, limit: 5)
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
    
    func getRestaurantList(offset: Int, limit: Int){
        guard let url = URL(string: Constants.BASE_URL + Constants.ALL_RESTAURANTS) else {
            print("BAD URL: \(Constants.BASE_URL)\(Constants.ALL_RESTAURANTS)")
            return
        }
        
        let parameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Failed to create components from URL: \(url)")
            return
        }
        
        components.queryItems = parameters
        
        guard let urlWithParameters = components.url else{
            print("Failed to create url with parameters: \(parameters.description)")
            return
        }
        
        var request = URLRequest(url: urlWithParameters)
        request.httpMethod = "GET"
        NetworkingManager.download(request: request)
            .decode(type: [Restaurant].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] restaurants in
                self?.restaurantList = restaurants
            })
            .store(in: &cancellables)

    }
}
