//
//  LoginViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.02.2023.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject{
    @Published var credentials = Credentials(email: "", password: "")
    @Published var authentication = Authentication()
    
    @Published var showCredentialsError = false
    @Published var error: Authentication.AuthenticationError?
    
    @Published var signInButtonTapped = false
    @Published var showProcessingView = false
    
    let authService = AuthService.shared
    var cancellables = Set<AnyCancellable>()
    
    
    func signIn(){
        if credentials.email.isEmpty || credentials.password.isEmpty{
            error = .emailOrPasswordNotProvided
            showCredentialsError = true
            return
        }
        showProcessingView = true
        
        authService.authenticate(with: credentials)
        
        authService.$isAuthenticated
            .sink {[weak self] authenticated in
                guard let authenticated = authenticated else{return}
                self?.showProcessingView = false
                if !authenticated{
                    self?.showCredentialsError = true
                    self?.error = .invalidCredentials
                }else{
                    
                }
            }
            .store(in: &cancellables)
    }
    
    func authenticateUsingBiometrics(){
        authentication.requestBiomotricAuthentication()
    }
}
