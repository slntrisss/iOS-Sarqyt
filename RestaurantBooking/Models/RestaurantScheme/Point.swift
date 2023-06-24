//
//  Point.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 31.03.2023.
//

import Foundation

struct RestaurantScheme: Codable{
    let id: String
    let numberOfRows: Int
    let numberOfColumns: Int
    let floors: [Floor]
}

struct Floor: Codable{
    let id: String
    let groups: [SchemeItemGroup]
}

struct SchemeItemGroup: Codable, Identifiable{
    let id: String
    let reserved: Bool
    let tableItem: [SchemeItem]
    let chairItems: [SchemeItem]
    let sofaItems: [SchemeItem]
}

struct SchemeItem: Codable, Identifiable{
    var id: String
    var type: SchemeItemType
    let items: [Point]
}

struct Point: Codable{
    let x: Int
    let y: Int
}

enum SchemeItemType: String, Codable{
    case TABLE = "TABLE"
    case CHAIR = "CHAIR"
    case SOFA = "SOFA"
    case WALL = "WALL"
    case empty = "empty"
}
