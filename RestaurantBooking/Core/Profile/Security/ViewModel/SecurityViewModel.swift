//
//  SecurityViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 02.04.2023.
//

import LocalAuthentication

class SecurityViewModel: ObservableObject{
    
    @Published var touchIdEnabled = false
    @Published var faceIdEnbaled = false
    
    @Published var changePassword = false
    var supportsTouchID: Bool{
        return Biometrics.biometricType() == .touch
    }
    
    var supportsFaceID: Bool{
        return Biometrics.biometricType() == .face
    }
}
