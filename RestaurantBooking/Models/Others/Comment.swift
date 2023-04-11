//
//  Comment.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 11.03.2023.
//

import Foundation

struct Comment: Identifiable, Codable{
    let id: String
    let date: Date
    let user: User
    let text: String
    let rating: Int
}
