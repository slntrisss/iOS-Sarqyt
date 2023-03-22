//
//  OrderedFood.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 22.03.2023.
//

import Foundation
struct OrderedFood: Codable, Identifiable{
    let id: String
    let food: Food
    var count: Int
    var price: Double
    var specialWishes: String
}
