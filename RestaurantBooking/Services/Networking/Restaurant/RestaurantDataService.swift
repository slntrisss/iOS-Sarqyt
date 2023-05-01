//
//  RestaurantDataService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 03.04.2023.
//

import Combine
import Foundation

class RestaurantDataService{
    
    @Published var recommendedRestaurantsPreviewList: [Restaurant]? = nil
    @Published var promotedRestaurantsPreviewList: [Restaurant]? = nil
    @Published var restaurantList: [Restaurant]? = nil
    @Published var recommendedRestaurants: [Restaurant] = []
    @Published var promotedRestaurants: [Restaurant] = []
    var cancellables = Set<AnyCancellable>()
    
    var restaurantListSubscription: AnyCancellable?
    var recommendedRestaurantsSubscription: AnyCancellable?
    var promotedRestaurantsSubscription: AnyCancellable?
    
    static let instance = RestaurantDataService()
    let token = AuthService.shared.getToken().trimmingCharacters(in: .whitespacesAndNewlines)
    
    private init(){ }
    
    func getAllRestaurants(){
        getRecommendedPreviewRestaurants()
        getPromotedRestaurants()
        getRestaurantList(offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
    }
    
    private func getRecommendedPreviewRestaurants(){
        let urlString = Constants.BASE_URL + Constants.RECOMMENDATIONS_PREVIEW
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        NetworkingManager.download(request: request)
            .decode(type: [Restaurant].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] restaurants in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    self?.recommendedRestaurantsPreviewList = restaurants
                }
            })
            .store(in: &cancellables)

    }
    
    private func getPromotedRestaurants(){
        let urlString = Constants.BASE_URL + Constants.PROMOTIONS_PREVIEW
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        NetworkingManager.download(request: request)
            .decode(type: [Restaurant].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] restaurants in
                DispatchQueue.main.asyncAfter(deadline: .now() + 4){
                    self?.promotedRestaurantsPreviewList = restaurants
                }
            })
            .store(in: &cancellables)
    }
    
    private func getRestaurants(){
        let urlString = Constants.BASE_URL + Constants.ALL_RESTAURANTS
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        NetworkingManager.download(request: request)
            .decode(type: [Restaurant].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] restaurants in
                DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                    self?.restaurantList = restaurants
                }
            })
            .store(in: &cancellables)
    }
    
    func getRestaurantList(offset: Int, limit: Int){
        let urlString = Constants.BASE_URL + Constants.ALL_RESTAURANTS
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
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
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            restaurantListSubscription = NetworkingManager.download(request: request)
                .decode(type: [Restaurant].self, decoder: JSONDecoder())
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] restaurants in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                        self?.restaurantList = restaurants
                        if restaurants.count == 0{
                            self?.restaurantListSubscription?.cancel()
                        }
                    }
                })
        }catch let error{
            print(error.localizedDescription)
        }

    }
    
    func getRecommendedRestaurants(offset: Int, limit: Int){
        let urlString = Constants.BASE_URL + Constants.RECOMMENDED_RESTAURANTS
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
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
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
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
        let urlString = Constants.BASE_URL + Constants.PROMOTED_RESTAURANTS
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
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
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
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
        let urlString = Constants.BASE_URL + Constants.BOOKMARK_RESTAURANT + "/\(id)"
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return nil
        }
        var restaurant: Restaurant? = nil
        let json = ["bookmarked": bookmarked]
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
