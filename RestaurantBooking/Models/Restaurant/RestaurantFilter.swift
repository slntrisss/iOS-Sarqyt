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
    var facilities: [String]
    var accomodationTypes: [String]
}

struct FilterData: Codable{
    var cities: [String]
    var categories: [String]
    var minPrice: Double
    var maxPrice: Double
    var ratings: [Int] //By default from 1 -> 5
    var facilities: [String]
    var accomodationTypes: [String]
}
