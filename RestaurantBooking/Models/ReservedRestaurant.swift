//
//  ReservedRestaurant.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 01.04.2023.
//

import Foundation

struct ReservedRestaurant: Codable{
    let id: String
    let image: String
    let restaurantName: String
    let city: String
    let location: String
    let bookingStatus: BookingStatus
}
