//
//  PasscodeViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 30.04.2023.
//

import Foundation
import LocalAuthentication
import SwiftUI

class PasscodeViewModel: ObservableObject{
    @Published var enteredNumbers: [Int] = Array(repeating: -1, count: 4)
    @Published var showBioIcon = true
    @Published var showLockInfoLabel = false
    @Published var showBiometricsAlert = false
    @Published var authSuccess = false
    @Published var passcodeNotValid = false
    
    var index = -1
    var bioIdType = ""
    
    @Published var topLabelText = "Enter a passcode"
    
    //Set new passcode
    @Published var passcode: [Int] = Array(repeating: -1, count: 4)
    @Published var passcodeVerification: [Int] = Array(repeating: -1, count: 4)
    lazy var passcodeIndex = -1
    lazy var verificationPasscodeIndex = -1
    @Published var offset: CGFloat = 0
    @Published var type: PasscodeType
    var scrollToIndex = 0
    let authService = AuthService.shared
    
    init(type: PasscodeType){
        self.type = type
        switch Biometrics.biometricType(){
        case .touch:
            bioIdType = "Touch ID"
        case .face:
            bioIdType = "Face ID"
        case .none:
            bioIdType = ""
        }
    }
    
    func numberTapped(number: Int){
        switch type{
        case .passcode, .verifyIdentity:
            fillPasscode(number: number, passcode: &enteredNumbers, index: &index)
        case .createdPasscode:
            fillPasscode(number: number, passcode: &passcode, index: &passcodeIndex)
        case .passcodeVerification:
            fillPasscode(number: number, passcode: &passcodeVerification, index: &verificationPasscodeIndex)
        }
    }
    
    func deleteNumber(){
        switch type{
        case .passcode, .verifyIdentity:
            deletePasscodeNumber(index: &index, passcode: &enteredNumbers)
        case .createdPasscode:
            deletePasscodeNumber(index: &passcodeIndex, passcode: &passcode)
        case .passcodeVerification:
            deletePasscodeNumber(index: &verificationPasscodeIndex, passcode: &passcodeVerification)
        }
    }
    
    func displayCircles(index: Int) -> Bool{
        switch type{
        case .passcode, .verifyIdentity:
            return enteredNumbers[index] != -1
        case .createdPasscode:
            return passcode[index] != -1
        case .passcodeVerification:
            return passcodeVerification[index] != -1
        }
        
    }
    
    func checkBioIdentity(){
        if bioIdType.count != 0 && (type == .passcode || type == .verifyIdentity) {
            checkIdentity()
        }
    }
    
    var bioImageName: String{
        switch Biometrics.biometricType(){
        case .face :
            return "faceid"
        case .touch:
            return "touchid"
        case .none:
            showBioIcon = false
            return ""
        }
    }
    
    var showBioIDIcon: Bool{
        return (type == .passcode || type == .verifyIdentity) && showBioIcon
    }
    
    //MARK: Bio ID check
    
    var bioAlertTile: String{
        return "Eanble \(bioIdType)"
    }
    
    var bioAlertMessage: String{
        return "To unlock this app using \(bioIdType), you need to enable \(bioIdType) authentication in settings."
    }
    
    private func checkIdentity(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Allow to use \"FaceID\" information to unlock the data."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {[weak self] success, error in
                if success{
                    DispatchQueue.main.async {
                        self?.authSuccess = true
                    }
                } else {
                    if let error = error as? LAError{
                        if error.code == .biometryNotEnrolled{
                            DispatchQueue.main.async {
                                self?.showBiometricsAlert = true
                            }
                        }
                    }
                    print("Error occured while evaluating biometrics")
                }
            }
        } else {
            self.showBiometricsAlert = true
            print("No support for biometrics...")
        }
    }
    
    enum PasscodeType{
        case passcode
        case verifyIdentity
        case createdPasscode
        case passcodeVerification
    }
}

//MARK: - Passcode creation
extension PasscodeViewModel{
    
    func fillPasscode(number: Int, passcode: inout [Int], index: inout Int){
        if index < 3 {
            index += 1
            passcode[index] = number
        }
        if index == 3{
            if type == .passcode || type == .verifyIdentity {
                let savedPasscode = authService.getPasscode()
                
                for i in 0...3{
                    if savedPasscode[i] != passcode[i]{
                        print("Not valid passcode")
                        authSuccess = false
                        passcodeNotValid = true
                        
                        passcode = Array(repeating: -1, count: 4)
                        index = -1
                        return
                    }
                }
                authSuccess = true
                if type == .passcode{
                    authService.authenticateUsingPasscode()
                }
                
            } else if type == .createdPasscode{
                type = .passcodeVerification
                scrollToIndex = 1
                topLabelText = "Verify passcode"
                
            } else if type == .passcodeVerification{
                var isValidPasscode = true
                
                for i in 0...3{
                    if passcode[i] != self.passcode[i]{
                        isValidPasscode = false
                    }
                }
                
                if !isValidPasscode{
                    type = .createdPasscode
                    scrollToIndex = 0
                    topLabelText = "Passcode did not match. Try again."
                    
                    self.passcodeIndex = -1
                    self.verificationPasscodeIndex = -1
                    self.passcode = Array(repeating: -1, count: 4)
                    self.passcodeVerification = Array(repeating: -1, count: 4)
                    
                    index = -1
                    passcode = Array(repeating: -1, count: 4)
                } else {
                    authService.savePasscode(passcode: self.passcode)
                    authSuccess = true
                }
            }
        }
    }
    
    func deletePasscodeNumber(index: inout Int, passcode: inout [Int]){
        if index >= 0 {
            passcode[index] = -1
            index -= 1
        }
    }
}
