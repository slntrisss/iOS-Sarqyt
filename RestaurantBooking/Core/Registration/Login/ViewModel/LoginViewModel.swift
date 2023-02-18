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
    @Published var showCredentialsError = false
    @Published var credentialsErrorMessage = ""
    @Published var signInButtonTapped = false
    let authService = AuthService.shared
    var cancellables = Set<AnyCancellable>()
    
    func signIn(){
        if credentials.email.isEmpty || credentials.password.isEmpty{
            showCredentialsError = true
        }
        
        authService.authenticate(with: credentials)
        
        authService.$isAuthenticated
            .sink {[weak self] authenticated in
                if !authenticated{
                    self?.showCredentialsError = true
                    self?.credentialsErrorMessage = "Provided Email or Password is invalid."
                }
            }
            .store(in: &cancellables)
    }
}
