//
//  Point.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 31.03.2023.
//

import Foundation

struct Point: Codable{
    let x: Int
    let y: Int
}

struct ItemGroup: Codable{
    let id: String
    let numberOfRows: Int
    let numberOfColumns: Int
    let tables: [Point]
    let chairs: [Point]
    let sofas: [Point]
}

struct RestaurantScheme: Codable{
    let itemGroups: [ItemGroup]
    let walls: [Point]
}
