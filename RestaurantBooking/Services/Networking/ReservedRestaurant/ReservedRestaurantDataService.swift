//
//  ReservedRestaurantDataService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.04.2023.
//

import Foundation
import Combine

class ReservedRestaurantDataService{
    
    @Published var ongoingRestaurants: [ReservedRestaurant]? = nil
    @Published var cancelledRestaurants: [ReservedRestaurant]? = nil
    @Published var completedRestaurants: [ReservedRestaurant]? = nil
    @Published var cancellBookingSuccess = false
    
    @Published var reservationDetails: ReservedRestaurantDetail? = nil
    
    var restaurantSubscription: AnyCancellable?
    var reservationDetailSubscription: AnyCancellable?
    var cancelBookingSubscription: AnyCancellable?
    
    let token = AuthService.shared.getToken().trimmingCharacters(in: .whitespacesAndNewlines)
    static let instance = ReservedRestaurantDataService()
    private init() { }
    
    func fecthRestaurants(for status: BookingStatus, offset: Int, limit: Int){
        let urlString = Constants.BASE_URL + Constants.RESERVED_RESTAURANTS_BASE_URL
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        
        let parameters = [
            URLQueryItem(name: "status", value: "\(status.rawValue)"),
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        
        do {
            let urlWithParameters = try NetworkingManager.constructURLWith(parameters: parameters, url: url)
            var request = URLRequest(url: urlWithParameters)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(token, forHTTPHeaderField: "Authorization")
            
            restaurantSubscription = NetworkingManager.download(request: request)
                .decode(type: [ReservedRestaurant].self, decoder: JSONDecoder())
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedRestaurants in
                    if fetchedRestaurants.count == 0{
                        self?.restaurantSubscription?.cancel()
//                        return
                    }
                    switch status{
                    case .ongoing:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            self?.ongoingRestaurants = fetchedRestaurants
                        }
                    case .completed:
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            self?.completedRestaurants = fetchedRestaurants
//                        }
                    default:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            self?.cancelledRestaurants = fetchedRestaurants
                        }
                    }
                    self?.restaurantSubscription?.cancel()
                }
            
        } catch let error {
            print("Error occured: \(error.localizedDescription)")
        }
        
    }
    
    func fetchReservedRestaurantDetail(for restaurantId: String, orderItemId: String){
        let urlString = Constants.BASE_URL + Constants.RESERVED_RESTAURANTS_DETAIL + "/\(orderItemId)"
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        reservationDetailSubscription = NetworkingManager.download(request: request)
            .decode(type: ReservedRestaurantDetail.self, decoder: JSONDecoder.defaultDecoder)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedDetails in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    self?.reservationDetails = fetchedDetails
                }
            }
    }
    
    func cancelBookingRestaurant(restaurant: ReservedRestaurant){
        let urlString = Constants.BASE_URL + Constants.CANCEL_RESERVED_RESTAURANT + "/\(restaurant.orderItemId)"
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        
        cancelBookingSubscription = URLSession.shared.dataTaskPublisher(for: request)
            .sink {[weak self] completion in
                switch completion{
                case .finished:
                    print("POST, Cancel booking Success")
                    self?.cancellBookingSuccess = true
                case .failure(let error):
                    print("Error cancel booking: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                print(response)
            }
        
        
        
    }
}
