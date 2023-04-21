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
    @Published var error: Authentication.AuthenticationError?
    
    @Published var signInButtonTapped = false
    @Published var showProcessingView = false
    
    var supportsBiometrics: Bool = true
    var isAuthenticated: Bool = false
    var biometricLabel: String = ""
    var biometricImageName: String = ""
    
    let authService = AuthService.shared
    var cancellables = Set<AnyCancellable>()
    
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
            error = .emailOrPasswordNotProvided
            showCredentialsError = true
            return
        }
        showProcessingView = true
        
        authService.authenticate(with: credentials)
        
        authService.$authStatus
            .sink {[weak self] authStatus in
                guard let authStatus = authStatus else{return}
                DispatchQueue.main.async {
                    self?.showProcessingView = false
                }
                if authStatus == .credentialsError{
                    DispatchQueue.main.async {
                        self?.showCredentialsError = true
                        self?.error = .invalidCredentials
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func authenticateUsingBiometrics(){
        authentication.requestBiomotricAuthentication()
    }
    
    var showBiometricsView: Bool{
        return isAuthenticated && supportsBiometrics
    }
}
