//
//  Restaurant.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import Foundation
import SwiftUI

struct Restaurant: Codable, Identifiable{
    let id: String
    let name: String
    let address: Address
    let details: RestaurantDetails
    let image: String
    let rating: Double
    let reviewAmount: Int
    let reserveAmount: Double
    var bookmarked: Bool
}

struct Address: Codable{
    let city: String
    let location: String
}

struct RestaurantDetails: Codable{
}
