//
//  Book.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 12.03.2023.
//

import Foundation

struct Book: Identifiable, Codable{
    let id: String
    var user: User
    var date: Date
    var selectedTime: Date
    var numberOfGuests: Int
    
    init(){
        self.id = UUID().uuidString
        self.user = User(id: UUID().uuidString,
                         firstName: "",
                         lastName: "",
                         email: "",
                         birthDate: Date(),
                         phoneNumber: "",
                         gender: "")
        self.date = Date()
        self.selectedTime = Date()
        self.numberOfGuests = 1
    }
}
