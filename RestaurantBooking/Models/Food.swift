//
//  Food.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.03.2023.
//

import Foundation

struct Food: Codable{
    let id: String
    let name: String
    let image: String
    let type: FoodType
    let price: Int
    let description: String
}
