//
//  ReservedRestaurantDetail.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 01.04.2023.
//

import Foundation
struct ReservedRestaurantDetail: Codable{
    let id: String
    let restaurantName: String
    let restaurantImage: String
    let city: String
    let location: String
    let tableNumber: Int
    let reservedDate: String
    let reservedTime: String
    let numberOfGuests: Int
    let specialWishes: String
    let orderedFoods: [OrderedFood]
    let restaurantBookingPrice: Double
    let orderedFoodsPrice: Double
    let servicePrice: Double
    let totalPrice: Double
}
