//
//  RestaurantDetailDataService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.04.2023.
//

import Foundation
import Combine

class RestaurantDetailDataService{
    @Published var details: RestaurantDetails? = nil
    @Published var ratedRestaurant: RatedRestaurantData? = nil
    @Published var previewComments: [Comment]? = nil
    @Published var comments: [Comment]? = nil
    
    static let instance = RestaurantDetailDataService()
    let token = AuthService.shared.getToken().trimmingCharacters(in: .whitespacesAndNewlines)
    private init(){ }
    
    var commentsSubscription: AnyCancellable?
    var rateRestaurantSubscription: AnyCancellable?
    var cancellables = Set<AnyCancellable>()
    
    func fetchDetail(for id: String){
        let urlString = Constants.BASE_URL + Constants.DETAILS + "/\(id)"
        guard let url = URL(string: urlString) else{
            print("BAD URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        NetworkingManager.download(request: request)
            .decode(type: RestaurantDetails.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedDetails in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    self?.details = fetchedDetails
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchPreviewComments(for id: String, offset: Int, limit: Int){
        let urlString = Constants.BASE_URL + Constants.DETAILS + "/\(id)" + Constants.COMMENTS
        guard let url = URL(string: urlString) else{
            print("BAD URL: \(urlString)")
            return
        }
        
        let parameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        do{
            let urlStringWithParameters = try NetworkingManager.constructURLWith(parameters: parameters, url: url)
            
            var request = URLRequest(url: urlStringWithParameters)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(token, forHTTPHeaderField: "Authorization")
            
            NetworkingManager.download(request: request)
                .decode(type: [Comment].self, decoder: JSONDecoder.DaurbeksDatesFormatter)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedComments in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        self?.previewComments = []
                        for i in fetchedComments.indices{
                            self?.previewComments?.append(fetchedComments[i])
                            if i == 2{
                                break
                            }
                        }
                    }
                }
                .store(in: &cancellables)
            
        }catch let error{
            print("Error occured: \(error.localizedDescription)")
        }
    }
    
    func fetchComments(for id: String, offset: Int, limit: Int){
        let urlString = Constants.BASE_URL + Constants.DETAILS + "/\(id)" + Constants.COMMENTS
        guard let url = URL(string: urlString) else{
            print("BAD URL: \(urlString)")
            return
        }
        
        let parameters = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        do{
            let urlStringWithParameters = try NetworkingManager.constructURLWith(parameters: parameters, url: url)
            var request = URLRequest(url: urlStringWithParameters)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(token, forHTTPHeaderField: "Authorization")
            
            commentsSubscription = NetworkingManager.download(request: request)
                .decode(type: [Comment].self, decoder: JSONDecoder.DaurbeksDatesFormatter)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedComments in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        self?.comments = fetchedComments
                        if fetchedComments.count == 0{
                            self?.commentsSubscription?.cancel()
                        }
                    }
                }
            
        }catch let error{
            print("Error occured: \(error.localizedDescription)")
        }
    }
    
    func rateRestaurant(for id: String, ratedRestaurantData: RatedRestaurantData){
        let urlString = Constants.BASE_URL + Constants.DETAILS + Constants.RATE_RESTAURANT
        guard let url = URL(string: urlString) else{
            print("BAD URL: \(urlString)")
            return
        }
        print(ratedRestaurantData)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do{
            let jsonData = try JSONEncoder().encode(ratedRestaurantData)
            request.httpBody = jsonData
            
            rateRestaurantSubscription = NetworkingManager.post(request: request)
                .decode(type: RatedRestaurantData.self, decoder: JSONDecoder.defaultDecoder)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedRatedRestaurant in
                    self?.ratedRestaurant = fetchedRatedRestaurant
                    
                }
        }catch let error{
            print("Error occured while encoding data: \(error)")
        }
        
        
    }
}
