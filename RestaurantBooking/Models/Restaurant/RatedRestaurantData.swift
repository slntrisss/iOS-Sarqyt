//
//  RatedRestaurantData.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 17.06.2023.
//

import Foundation

struct RatedRestaurantData: Codable{
    let id: String
    let restaurantId: String
    let selectedStars: Int
    let comment: String
}
