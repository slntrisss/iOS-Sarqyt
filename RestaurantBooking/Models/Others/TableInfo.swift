//
//  TableInfo.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 16.04.2023.
//

import Foundation

struct TableInfo: Codable, Identifiable{
    let id: String
    let floor: Int
    let numberOfChairs: Int
    let reservePrice: Double
    let description: String
    let images: [String]
}
