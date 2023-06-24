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
    
    let token = AuthService.shared.getToken().trimmingCharacters(in: .whitespacesAndNewlines)
    static let instance = BookDataService()
    private init(){ }
    
    func fetchBookingRestaurant(for restaurantId: String){
        let urlString = Constants.BASE_URL + Constants.BOOKING_RESTAURANT + "/\(restaurantId)"
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        bookingRestaurantSubscription = NetworkingManager.download(request: request)
            .decode(type: BookingRestaurant.self, decoder: JSONDecoder.DaurbeksDatesFormatter)
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
            "date" : date.validJSONDateString,
            "groupId" : groupId
        ]
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        //TODO: Uncomment for real data from SERVER
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
    
    func bookRestaurant(bookedRestaurant: BookedRestaurant, orderedFoods: [OrderedFood]){
        let urlString = Constants.BASE_URL + Constants.BOOK_BASE_URL + "/\(bookedRestaurant.restaurantId)"
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")

        do{
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            
            let jsonRestaurantData = try encoder.encode(bookedRestaurant)
            let jsonOrderedFoodsData = try encoder.encode(orderedFoods)
            
            var jsonDictionary = [String: Any]()
            jsonDictionary["bookedRestaurant"] = try JSONSerialization.jsonObject(with: jsonRestaurantData)
            jsonDictionary["orderedFoods"] = try JSONSerialization.jsonObject(with: jsonOrderedFoodsData)
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])

            request.httpBody = jsonData
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            

            bookingRestaurantSubscription = URLSession.shared.dataTaskPublisher(for: request)
                .sink(receiveCompletion: {[weak self] completion in
                    switch completion{
                    case .finished:
                        print("POST success")
                        self?.restaurantBooked = true
                    case .failure(let error):
                        print("POST failed: \(error.localizedDescription)")
                    }
                }, receiveValue: { (data, response) in
                    print(response)
                })
        }catch let error{
            print("Error occured: \(error.localizedDescription)")
        }
    }
}

extension BookDataService{
    
}
