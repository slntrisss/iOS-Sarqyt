//
//  OrderedFoodViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 23.03.2023.
//

import Foundation

class OrderedFoodViewModel: ObservableObject{
    @Published var orderedFoods: [OrderedFood]
    init(orderedFoods: [OrderedFood]){
        self.orderedFoods = orderedFoods
    }
}
