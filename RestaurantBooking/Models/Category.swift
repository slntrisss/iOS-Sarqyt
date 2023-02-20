//
//  Category.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import Foundation

enum Category: String, Hashable, CaseIterable{
    case recommended = "Recommended"
    case trending = "Trending"
    case popular = "Popular"
    case highPrice = "High Price"
    case lowPrice = "Low Price"
}
