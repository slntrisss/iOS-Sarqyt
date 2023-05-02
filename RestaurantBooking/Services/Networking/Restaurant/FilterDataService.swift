//
//  FilterDataService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 23.04.2023.
//

import Foundation
import Combine

class FilterDataService{
    @Published var restaurants: [Restaurant] = []
    @Published var filterData: FilterData? = nil
    
    let authService = AuthService.shared
    
    var filteredRestaurantSubscription: AnyCancellable?
    var filterDataSubscription: AnyCancellable?
    
    static let instance = FilterDataService()
    private init(){ }
    
    func fetchRestaurants(by searchQuery: String){
        let urlString = Constants.BASE_URL + Constants.FILTERED_RESTAURANTS
        let token = authService.getToken().trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: urlString) else{
            print("BAD URL: \(urlString)")
            return
        }
        
        let parameters = [
            URLQueryItem(name: "filter", value: "\(searchQuery)")
        ]
        
        do {
            let urlWithParameters = try NetworkingManager.constructURLWith(parameters: parameters, url: url)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            filteredRestaurantSubscription = NetworkingManager.download(request: request)
                .decode(type: [Restaurant].self, decoder: JSONDecoder())
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedRestaurants in
                    self?.restaurants = fetchedRestaurants
                    self?.filteredRestaurantSubscription?.cancel()
                }
        } catch let error {
            print("Error occured: \(error.localizedDescription)")
        }
    }
    
    func fetchRestaurants(by filter: RestaurantFilter){
        let urlString = Constants.BASE_URL + Constants.FILTERED_RESTAURANTS
        let token = authService.getToken().trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: urlString) else{
            print("BAD URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONEncoder().encode(filter)
            request.httpBody = jsonData
            
            filteredRestaurantSubscription = NetworkingManager.post(request: request)
                .decode(type: [Restaurant].self, decoder: JSONDecoder())
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] fetchedRestaurants in
                    self?.restaurants = fetchedRestaurants
                    self?.filteredRestaurantSubscription?.cancel()
                })
        } catch let error {
            print("Error occured: \(error.localizedDescription)")
        }
    }
    
    func getFilterData(){
        let urlString = Constants.BASE_URL + Constants.FILTER_DATA
        let token = authService.getToken().trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: urlString) else{
            print("BAD URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        filterDataSubscription = NetworkingManager.download(request: request)
            .decode(type: FilterData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] fetchedFilterData in
                self?.filterData = fetchedFilterData
                self?.filterDataSubscription?.cancel()
            })
    }
}
