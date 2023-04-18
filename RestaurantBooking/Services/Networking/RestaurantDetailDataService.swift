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
    @Published var previewComments: [Comment] = []
    @Published var comments: [Comment] = []
    
    static let instance = RestaurantDetailDataService()
    private init(){ }
    
    var commentsSubscription: AnyCancellable?
    var cancellables = Set<AnyCancellable>()
    
    func fetchDetail(for id: String){
        let urlString = Constants.BASE_URL + Constants.DETAILS + "/\(id)"
        guard let url = URL(string: urlString) else{
            print("BAD URL: \(urlString)")
            return
        }
        
        NetworkingManager.download(url: url)
            .decode(type: RestaurantDetails.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedDetails in
                self?.details = fetchedDetails
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
            NetworkingManager.download(request: request)
                .decode(type: [Comment].self, decoder: JSONDecoder.defaultDecoder)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedComments in
                    self?.previewComments = fetchedComments
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
            commentsSubscription = NetworkingManager.download(request: request)
                .decode(type: [Comment].self, decoder: JSONDecoder.defaultDecoder)
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedComments in
                    self?.comments = fetchedComments
                    if fetchedComments.count == 0{
                        self?.commentsSubscription?.cancel()
                    }
                }
            
        }catch let error{
            print("Error occured: \(error.localizedDescription)")
        }
    }
}
