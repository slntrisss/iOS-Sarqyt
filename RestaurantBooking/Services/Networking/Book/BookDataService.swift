//
//  BookDataService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 19.04.2023.
//

import Foundation
import Combine

class BookDataService{
    
    @Published var bookingRestaurant: BookingRestaurant? = nil
    @Published var tableInfo: TableInfo? = nil
    
    var bookingRestaurantSubscription: AnyCancellable?
    var tableInfoSubscription: AnyCancellable?
    
    static let instance = BookDataService()
    private init(){ }
    
    func fetchBookingRestaurant(for restaurantId: String){
        let urlString = Constants.BASE_URL + "/\(restaurantId)" + Constants.BOOKING_RESTAURANT
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        
        bookingRestaurantSubscription = NetworkingManager.download(url: url)
            .decode(type: BookingRestaurant.self, decoder: JSONDecoder.defaultDecoder)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] fetchedBookingRestaurant in
                self?.bookingRestaurant = fetchedBookingRestaurant
                self?.bookingRestaurantSubscription?.cancel()
            })
    }
    
    func fetchTableInfo(for restaurantId: String, date: Date, groupId: String){
        let urlString = Constants.BASE_URL + Constants.TABLE_INFO
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        
        let requestBody: [String: Any] = [
            "restaurantId" : restaurantId,
            "date" : date,
            "groupId" : groupId
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            request.httpBody = jsonData
            
            tableInfoSubscription = NetworkingManager.download(request: request)
                .decode(type: TableInfo.self, decoder: JSONDecoder())
                .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] fetchedTableInfo in
                    self?.tableInfo = fetchedTableInfo
                    self?.tableInfoSubscription?.cancel()
                }
        }catch let error{
            print("Error occured: \(error.localizedDescription)")
        }
    }
}
