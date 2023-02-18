//
//  AuthService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.02.2023.
//

import Foundation

class AuthService{
    
    @Published var isAuthenticated: Bool?
    
    static let shared = AuthService()
    
    func authenticate(with credentials: Credentials){
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            //do something
            self.isAuthenticated = false
        }
    }
}
