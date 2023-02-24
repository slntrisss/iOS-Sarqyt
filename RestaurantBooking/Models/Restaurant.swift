//
//  Restaurant.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import Foundation
import SwiftUI

struct Restaurant: Codable, Identifiable, Equatable, Hashable{
    let id: String
    let name: String
    let address: Address
    let details: RestaurantDetails
    let image: String
    let rating: Double
    let reviewAmount: Int
    let reserveAmount: Double
    var bookmarked: Bool
    
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Address: Codable, Hashable{
    let city: String
    let location: String
}

struct RestaurantDetails: Codable, Hashable{
}
