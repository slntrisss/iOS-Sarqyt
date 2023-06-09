//
//  PageInfo.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 17.04.2023.
//

import Foundation

class PageInfo{
    
    var itemsFromEndTreshold: Int
    var itemsLoaded: Int
    var offset: Int
    
    init(itemsLoaded: Int, itemsFromEndTreshold: Int = 5, offset: Int = 1) {
        self.itemsFromEndTreshold = itemsFromEndTreshold
        self.itemsLoaded = itemsLoaded
        self.offset = offset
    }
}
