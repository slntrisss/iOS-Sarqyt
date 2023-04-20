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
    @Published var restaurantBooked: Bool? = nil
    
    var bookingRestaurantSubscription: AnyCancellable?
    var tableInfoSubscription: AnyCancellable?
    var bookRestaurantSubscription: AnyCancellable?
    
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
        let urlString = Constants.BASE_URL + "/\(restaurantId)" + Constants.TABLE_INFO
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        
        let requestBody: [String: Any] = [
            "restaurantId" : restaurantId,
            "date" : date.validJSONDateString,
            "groupId" : groupId
        ]
        var request = URLRequest(url: url)
        //TODO: Uncomment for real data from SERVER
//        request.httpMethod = "POST"
        request.httpMethod = "GET"
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
//            request.httpBody = jsonData
            
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
    
    func bookRestaurant(bookedRestaurant: BookedRestaurant, orderedFoods: [OrderedFood]){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){[weak self] in
            self?.restaurantBooked = true
        }
//        let urlString = Constants.BASE_URL + "/\(bookedRestaurant.restaurantId)" + Constants.BOOK_BASE_URL
//        guard let url = URL(string: urlString) else {
//            print("BAD URL: \(urlString)")
//            return
//        }
//
//
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        do{
//            let jsonRestaurantData = try JSONEncoder().encode(bookedRestaurant)
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = jsonRestaurantData
//
//            bookingRestaurantSubscription = URLSession.shared.dataTaskPublisher(for: request)
//                .sink(receiveCompletion: { completion in
//                    switch completion{
//                    case .finished:
//                        print("POST success")
//                    case .failure(let error):
//                        print("POST failed: \(error.localizedDescription)")
//                    }
//                }, receiveValue: { (data, response) in
//                    print(response)
//                })
//        }catch let error{
//            print("Error occured: \(error.localizedDescription)")
//        }
    }
}

extension BookDataService{
    
}
