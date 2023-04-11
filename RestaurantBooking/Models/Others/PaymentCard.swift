//
//  PaymentCard.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 02.04.2023.
//

import Foundation

struct PaymentCard: Codable, Identifiable{
    let id: String
    let cardNumber: String
    let expirationMonth: String
    let expirationYear: String
    let cvv: String
    var inUse: Bool
}
