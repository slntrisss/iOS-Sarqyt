//
//  PasscodeViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 30.04.2023.
//

import Foundation
import LocalAuthentication

class PasscodeViewModel: ObservableObject{
    @Published var enteredNumbers: [Int] = Array(repeating: -1, count: 4)
    @Published var showBioIcon = true
    @Published var showLockInfoLabel = false
    @Published var showBiometricsAlert = false
    @Published var authSuccess = false
    
    var index = 0
    var bioIdType = ""
    
    init(){
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
        if index < 4 {
            enteredNumbers.insert(number, at: index)
            index += index == 3 ? 0 : 1
        }
    }
    
    func deleteNumber(){
        if index >= 0 {
            enteredNumbers[index] = -1
            index -= index == 0 ? 0 : 1
        }
    }
    
    func displayCircles(index: Int) -> Bool{
        return enteredNumbers[index] != -1
    }
    
    func checkBioIdentity(){
        checkIdentity()
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
    
    var topLabelText: String {
        return "Enter a passcode"
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
}
