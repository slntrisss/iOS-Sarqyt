//
//  MapDataService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 21.04.2023.
//

import Foundation
import Combine

class MapDataService{
    @Published var restaurants: [Restaurant]? = nil
    
    var restaurantListSubscription: AnyCancellable?
    
    let token = AuthService.shared.getToken().trimmingCharacters(in: .whitespacesAndNewlines)
    static let instance = MapDataService()
    private init(){ }
    
    func fetchRestaurants(offset: Int, limit: Int){
        let urlString = Constants.BASE_URL + Constants.MAP_BASE_URL
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
            request.setValue(token, forHTTPHeaderField: "Authorization")
            
            restaurantListSubscription = NetworkingManager.download(request: request)
                .decode(type: [Restaurant].self, decoder: JSONDecoder())
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedRestaurants in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        self?.restaurants = fetchedRestaurants
                        if fetchedRestaurants.count == 0{
                            self?.restaurantListSubscription?.cancel()
                        }
                    }
                }
        }catch let error{
            print("Error occured: \(error.localizedDescription)")
        }
    }
}
