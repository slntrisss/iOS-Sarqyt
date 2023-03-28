//
//  OrderViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 25.03.2023.
//

import Foundation

class OrderViewModel: ObservableObject{
    @Published var orderedFoods: [OrderedFood]
    @Published var bookingRestaurant: BookingRestaurant
    @Published var showAllPaymentsMethodLists = false
    init(orderedFoods: [OrderedFood], bookingRestaurant: BookingRestaurant){
        self.orderedFoods = orderedFoods
        self.bookingRestaurant = bookingRestaurant
    }
}
