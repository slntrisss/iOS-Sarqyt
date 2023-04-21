//
//  ResponseToken.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 21.04.2023.
//

import Foundation

struct AuthResponse: Codable{
    let accessToken: String
    let user: User
}

struct User: Codable{
    let email: String
    let id: Int
}
