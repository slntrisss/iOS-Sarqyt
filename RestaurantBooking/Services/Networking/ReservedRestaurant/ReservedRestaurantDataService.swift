//
//  ReservedRestaurantDataService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.04.2023.
//

import Foundation
import Combine

class ReservedRestaurantDataService{
    
    @Published var ongoingRestaurants: [Restaurant] = []
    @Published var cancelledRestaurants: [Restaurant] = []
    @Published var completedRestaurants: [Restaurant] = []
    
    @Published var reservationDetails: ReservedRestaurantDetail? = nil
    
    var restaurantSubscription: AnyCancellable?
    var reservationDetailSubscription: AnyCancellable?
    
    static let instance = ReservedRestaurantDataService()
    private init() { }
    
    func fecthRestaurants(for status: BookingStatus, offset: Int, limit: Int){
        let urlString = Constants.BASE_URL + Constants.RESERVED_RESTAURANTS_BASE_URL
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        
        let parameters = [
            URLQueryItem(name: "status", value: "\(status)"),
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        
        do {
            let urlWithParameters = try NetworkingManager.constructURLWith(parameters: parameters, url: url)
            var request = URLRequest(url: urlWithParameters)
            request.httpMethod = "GET"
            
            restaurantSubscription = NetworkingManager.download(request: request)
                .decode(type: [Restaurant].self, decoder: JSONDecoder())
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedRestaurants in
                    switch status{
                    case .ongoing:
                        self?.ongoingRestaurants = fetchedRestaurants
                    case .completed:
                        self?.completedRestaurants = fetchedRestaurants
                    default:
                        self?.cancelledRestaurants = fetchedRestaurants
                    }
                    self?.restaurantSubscription?.cancel()
                }
            
        } catch let error {
            print("Error occured: \(error.localizedDescription)")
        }
        
    }
    
    func fetchReservedRestaurantDetail(for restaurantId: String){
        let urlString = Constants.BASE_URL + Constants.RESERVED_RESTAURANTS_DETAIL + "/\(restaurantId)"
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        
        reservationDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: ReservedRestaurantDetail.self, decoder: JSONDecoder.defaultDecoder)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedDetails in
                self?.reservationDetails = fetchedDetails
            }
    }
}
