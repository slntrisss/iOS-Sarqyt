//
//  BookingRestaurant.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 25.03.2023.
//

import Foundation

struct BookingRestaurant: Codable, Identifiable{
    let id: String
    let availableBookingTimeInterval: [Date]
}
