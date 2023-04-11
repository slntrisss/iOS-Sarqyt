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
    let groups: [MapItemGroup]
    let walls: [Point]
    let map: [[String]]
}

struct MapItemGroup: Codable, Identifiable{
    let id: String
    let reserved: Bool
    let tableItem: [MapItem]
    let chairItems: [MapItem]
    let sofaItems: [MapItem]
}

struct MapItem: Codable, Identifiable{
    var id: String
    var type: MapItemType
    let items: [Point]
}

struct Point: Codable{
    let x: Int
    let y: Int
}

enum MapItemType: Character, Codable{
    case TABLE = "t"
    case CHAIR = "c"
    case SOFA = "s"
    case WALL = "w"
    case empty = "*"
}
