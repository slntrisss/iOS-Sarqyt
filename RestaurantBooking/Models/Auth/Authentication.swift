//
//  Authentication.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.02.2023.
//

import Foundation
import LocalAuthentication

class Authentication: ObservableObject{
    @Published var isAuthenticated = false
    
    enum BiometricType{
        case none
        case touchID
        case faceID
    }
    
    enum AuthenticationError: Error, LocalizedError, Identifiable {
        case emailOrPasswordNotProvided
        case invalidCredentials
        case userDoesNotExist
        case deniedAccess
        case noFaceIdEnrolled
        case noFingerprintEnrolled
        case biometrictError
        case credentialsNotSaved
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case .emailOrPasswordNotProvided:
                return NSLocalizedString("Either your email or password not provided. Please enter all required fields properly.", comment: "")
            case .invalidCredentials:
                return NSLocalizedString("Either your email or password are incorrect. Please try again.", comment: "")
            case .deniedAccess:
                return NSLocalizedString("You have denied access. Please go to the settings app and locate this application and turn Face ID on.", comment: "")
            case .noFaceIdEnrolled:
                return NSLocalizedString("You have not registered any Face Ids yet", comment: "")
            case .noFingerprintEnrolled:
                return NSLocalizedString("You have not registered any fingerprints yet.", comment: "")
            case .biometrictError:
                return NSLocalizedString("Your face or fingerprint were not recognized.", comment: "")
            case .credentialsNotSaved:
                return NSLocalizedString("Your credentials have not been saved. Do you want to save them after the next successful login?", comment: "")
            case .userDoesNotExist:
                return NSLocalizedString("User does not exist for provided credentials", comment: "")
            }
        }
    }
    
    func biometricType() -> BiometricType{
        let authContext = LAContext()
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        switch authContext.biometryType{
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            return .none
        }
    }
    
    func requestBiomotricAuthentication(){
        let context = LAContext()
        var error: NSError?
        
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if let error = error {
            switch error.code{
            case -6:
                print("Denied access")
            case -7:
                print("noFaceId/noTouchId enrolled")
            default:
                print("Biometric error")
            }
        }
        if canEvaluate{
            if context.biometryType != .none{
                let reason = "Allow access to your \"FaceId\" information to authenticate to the system."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                    if let error = error {
                        print("Biometric error: \(error)")
                    }else{
                        print("Success.")
                    }
                }
            }
        }
    }
}
