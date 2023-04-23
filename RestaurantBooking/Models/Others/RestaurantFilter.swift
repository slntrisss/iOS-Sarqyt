//
//  RestaurantFilter.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 24.02.2023.
//

import Foundation

struct RestaurantFilter: Codable{
    var city: String
    var category: String
    var fromPrice: Double
    var toPrice: Double
    var rating: Double
    var facility: String
    var accomodationType: String
}
