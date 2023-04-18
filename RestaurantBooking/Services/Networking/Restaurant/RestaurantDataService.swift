//
//  RestaurantDataService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 03.04.2023.
//

import Combine
import Foundation

class RestaurantDataService{
    
    @Published var recommendedRestaurantsPreviewList: [Restaurant] = []
    @Published var promotedRestaurantsPreviewList: [Restaurant] = []
    @Published var restaurantList: [Restaurant] = []
    @Published var recommendedRestaurants: [Restaurant] = []
    @Published var promotedRestaurants: [Restaurant] = []
    var cancellables = Set<AnyCancellable>()
    
    var restaurantListSubscription: AnyCancellable?
    var recommendedRestaurantsSubscription: AnyCancellable?
    var promotedRestaurantsSubscription: AnyCancellable?
    
    static let instance = RestaurantDataService()
    
    private init(){ }
    
    func getAllRestaurants(){
        getRecommendedPreviewRestaurants()
        getPromotedRestaurants()
        getRestaurantList(offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
    }
    
    private func getRecommendedPreviewRestaurants(){
        guard let url = URL(string: Constants.BASE_URL + Constants.RECOMMENDATIONS_PREVIEW) else {
            print("BAD URL: \(Constants.BASE_URL)\(Constants.RECOMMENDATIONS_PREVIEW)")
            return
        }
        
        NetworkingManager.download(url: url)
            .decode(type: [Restaurant].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] restaurants in
                self?.recommendedRestaurantsPreviewList = restaurants
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
                self?.promotedRestaurantsPreviewList = restaurants
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
        
        do{
            let urlWithParameters = try NetworkingManager.constructURLWith(parameters: parameters, url: url)
            var request = URLRequest(url: urlWithParameters)
            request.httpMethod = "GET"
            restaurantListSubscription = NetworkingManager.download(request: request)
                .decode(type: [Restaurant].self, decoder: JSONDecoder())
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] restaurants in
                    self?.restaurantList = restaurants
                    if restaurants.count == 0{
                        self?.restaurantListSubscription?.cancel()
                    }
                })
        }catch let error{
            print(error.localizedDescription)
        }

    }
    
    func getRecommendedRestaurants(offset: Int, limit: Int){
        guard let url = URL(string: Constants.BASE_URL + Constants.RECOMMENDED_RESTAURANTS) else {
            print("BAD URL: \(Constants.BASE_URL)\(Constants.RECOMMENDED_RESTAURANTS)")
            return
        }
        
        let parameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        do{
            let urlWithParameters = try NetworkingManager.constructURLWith(parameters: parameters, url: url)
            var request = URLRequest(url: urlWithParameters)
            request.httpMethod = "GET"
            
            recommendedRestaurantsSubscription = NetworkingManager.download(request: request)
                .decode(type: [Restaurant].self, decoder: JSONDecoder())
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] restaurants in
                    self?.recommendedRestaurants = restaurants
                    if restaurants.count == 0{
                        self?.recommendedRestaurantsSubscription?.cancel()
                    }
                }
        }catch let error{
            print("Error occured: \(error.localizedDescription)")
        }
    }
    
    func getPromotedRestaurants(offset: Int, limit: Int){
        guard let url = URL(string: Constants.BASE_URL + Constants.PROMOTED_RESTAURANTS) else {
            print("BAD URL: \(Constants.BASE_URL)\(Constants.PROMOTED_RESTAURANTS)")
            return
        }
        
        let parameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        do{
            let urlWithParameters = try NetworkingManager.constructURLWith(parameters: parameters, url: url)
            var request = URLRequest(url: urlWithParameters)
            request.httpMethod = "GET"
            
            promotedRestaurantsSubscription = NetworkingManager.download(request: request)
                .decode(type: [Restaurant].self, decoder: JSONDecoder())
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] restaurants in
                    self?.promotedRestaurants = restaurants
                    if restaurants.count == 0{
                        self?.promotedRestaurantsSubscription?.cancel()
                    }
                }
        }catch let error{
            print("Error occured: \(error.localizedDescription)")
        }
    }
    
    func bookmarkRestaurant(id: String, bookmarked: Bool) -> Restaurant?{
        guard let url = URL(string: Constants.BASE_URL + Constants.BOOKMARK_RESTAURANT + "/\(id)") else {
            print("BAD URL: \(Constants.BASE_URL)\(Constants.BOOKMARK_RESTAURANT)/\(id)")
            return nil
        }
        var restaurant: Restaurant? = nil
        let json = ["bookmarked": bookmarked]
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
            print(request.description)
            URLSession.shared.dataTaskPublisher(for: request)
                .map{ $0.data}
                .decode(type: Restaurant.self, decoder: JSONDecoder())
                .sink { completion in
                    switch completion{
                    case .finished:
                        print("Bookmarking completed successfully!")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: {  updatedRestaurant in
                    restaurant = updatedRestaurant
                }
                .store(in: &cancellables)

        }catch let error{
            print("Error occured: \(error.localizedDescription)")
        }
        return restaurant
    }
}
