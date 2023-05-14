//
//  FoodDataService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.04.2023.
//

import Foundation
import Combine

class FoodDataService: ObservableObject{
    @Published var foods: [Food]? = nil
    @Published var types: [FoodType] = []
    
    static let instance = FoodDataService()
    let token = AuthService.shared.getToken().trimmingCharacters(in: .whitespacesAndNewlines)
    var foodTypeSubscription: AnyCancellable?
    var foodListSubscription: AnyCancellable?
    
    private init() { }
    
    func fetchFoodTitles(for restaurantId: String){
        let urlString = Constants.BASE_URL + "/\(restaurantId)" + Constants.FOOD_TYPES
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        foodTypeSubscription = NetworkingManager.download(request: request)
            .decode(type: [FoodType].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedTypes in
                self?.types = fetchedTypes
                self?.foodTypeSubscription?.cancel()
            }
    }
    
    func fetchFoods(for restaurantId: String, of typeId: String, offset: Int, limit: Int){
        self.foodListSubscription?.cancel()
        let urlString = Constants.BASE_URL + "/\(restaurantId)" + Constants.FOOD_BASE_URL + "/\(typeId)" + Constants.FOOD_LIST
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
            
            foodListSubscription = NetworkingManager.download(request: request)
                .decode(type: [Food].self, decoder: JSONDecoder())
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] fetchedFoods in
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                        self?.foods = fetchedFoods
                        if fetchedFoods.count == 0{
                            self?.foodListSubscription?.cancel()
                        }
//                    }
                })
        }catch let error{
            print("Error occured: \(error.localizedDescription)")
        }
    }
}
