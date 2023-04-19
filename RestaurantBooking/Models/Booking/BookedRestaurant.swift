//
//  BookedRestaurant.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 30.03.2023.
//

import Foundation

struct BookedRestaurant: Codable, Identifiable{
    let id: String
    let restaurant: Restaurant
    var numberOfGuests: Int
    let selectedDate: Date
    let selectedTime: String
    let specialWishes: String
    var selectedTableId: String
}
