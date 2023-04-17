//
//  BookingStatus.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 04.03.2023.
//

import Foundation

enum BookingStatus: String, Codable{
    case ongoing = "Paid"
    case completed = "Completed"
    case cancelled = "Cancelled & Refunded"
    case none = ""
}
