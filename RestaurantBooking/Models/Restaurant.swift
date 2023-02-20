//
//  Restaurant.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import Foundation

struct Restaurant: Codable, Identifiable{
    let id: String
    let name: String
    let address: String
}
