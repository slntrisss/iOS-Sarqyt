//
//  OrderViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 25.03.2023.
//

import Foundation

class OrderViewModel: ObservableObject{
    @Published var orderedFoods: [OrderedFood]
    @Published var bookedRestaurant: BookedRestaurant
    @Published var showAllPaymentsMethodLists = false
    init(orderedFoods: [OrderedFood], bookedRestaurant: BookedRestaurant){
        self.orderedFoods = orderedFoods
        self.bookedRestaurant = bookedRestaurant
    }
    
    var bookingTimeInterval: String{
        return "\(bookedDate)\n\(bookedTime)"
    }
    
    private var bookedDate: String{
        return bookedRestaurant.selectedDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    private var bookedTime: String{
        return bookedRestaurant.selectedTime
    }
}
