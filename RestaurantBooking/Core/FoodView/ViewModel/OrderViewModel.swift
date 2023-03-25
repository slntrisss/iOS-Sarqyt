//
//  OrderViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 25.03.2023.
//

import Foundation

class OrderViewModel: ObservableObject{
    @Published var orderedFoods: [OrderedFood]
    @Published var bookedRestaurant: Restaurant
    init(orderedFoods: [OrderedFood], bookedRestaurant: Restaurant){
        self.orderedFoods = orderedFoods
        self.bookedRestaurant = bookedRestaurant
    }
}
