//
//  AuthStatus.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 21.04.2023.
//

import Foundation
enum AuthStatus: Equatable{
    case ok
    case credentialsError
    case authorizationError(message: String)
}
