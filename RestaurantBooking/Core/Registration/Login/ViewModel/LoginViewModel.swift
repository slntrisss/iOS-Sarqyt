//
//  LoginViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.02.2023.
//

import Foundation
import Combine
import LocalAuthentication

class LoginViewModel: ObservableObject{
    @Published var credentials = Credentials(email: "", password: "")
    @Published var authentication = Authentication()
    
    @Published var showCredentialsError = false
    var errorMessage: String = ""
    
    @Published var signInButtonTapped = false
    @Published var showProcessingView = false
    
    var supportsBiometrics: Bool = true
    var isAuthenticated: Bool = false
    var biometricLabel: String = ""
    var biometricImageName: String = ""
    
    let authService = AuthService.shared
    var signInSubscription : AnyCancellable?
    
    init(){
        initBiometrics()
    }
    
    private func initBiometrics(){
        switch Biometrics.biometricType(){
        case .face:
            biometricLabel = "Face ID"
            biometricImageName = "faceid"
        case .touch:
            biometricLabel = "Touch ID"
            biometricImageName = "touchid"
        case .none: supportsBiometrics = false
        }
        isAuthenticated = authService.authenticated()
    }
    
    func authenticate(){
        if isAuthenticated{
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "Allow to use \"FaceID\" information to unlock the data."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {[weak self] success, error in
                    if success{
                        self?.authService.authenticateUsingBiometrics()
                        self?.addSubscription()
                    } else {
                        print("Error occured while evaluating biometrics")
                    }
                }
            } else {
                print("No support for biometrics...")
            }
        }
    }
    
    func signIn(){
        if credentials.email.isEmpty || credentials.password.isEmpty{
            errorMessage = "Email or password is missing. Please try to fill all required fields."
            showCredentialsError = true
            return
        }
        showProcessingView = true
        
        authService.authenticate(with: credentials)
        
        addSubscription()
    }
    
    private func addSubscription(){
        signInSubscription = authService.$authStatus
            .sink {[weak self] fetchedStatus in
                DispatchQueue.main.async {
                    self?.showProcessingView = false
                }
                if let fetchedStatus = fetchedStatus{
                    switch fetchedStatus{
                    case .authorizationError(let message):
                        self?.showCredentialsError = true
                        self?.errorMessage = message
                    case .ok:
                        self?.signInSubscription?.cancel()
                    case .credentialsError:
                        print("credentialsError")
                    }
                }
            }
    }
    
    var showBiometricsView: Bool{
        return isAuthenticated && supportsBiometrics
    }
}
