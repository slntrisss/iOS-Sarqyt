//
//  User.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 11.03.2023.
//

import Foundation

struct Userr: Identifiable, Codable, Equatable{
    let id: String
    let profileImage: String
    let firstName: String
    let lastName: String
    let email: String
    let birthDate: Date
    let phoneNumber: String
    let gender: String
}
