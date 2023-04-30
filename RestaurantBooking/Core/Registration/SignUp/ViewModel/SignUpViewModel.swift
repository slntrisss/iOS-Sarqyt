//
//  SignUpViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 02.04.2023.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var rememberMe = false
    @Published var signUpButtonClicked = false
    @Published var signInWithGoogleTapped = false
    @Published var signInWithMetaTapped = false
    @Published var signInWithAppleTapped = false
    @Published var showPassword: Bool = false
    
    let authService = AuthService.shared
    var signUpStatusSubscription : AnyCancellable?
    @Published var showProgressView = false
    @Published var showCredentialsError = false
    var errorMessage = ""
    
    @Published var navigateToProfileSetupView = false
    @Published var setPasscode = false
    
    var cancellables = Set<AnyCancellable>()
    
    func signUp(){
        if password.isEmpty || email.isEmpty{
            errorMessage = "Email or password is missing. Please try to fill all required fields."
            showCredentialsError = true
            return
        }
        if confirmPassword != password{
            errorMessage = "Provided password are not identical."
            showCredentialsError = true
            return
        }
        showProgressView = true
        let credentials = Credentials(email: email, password: password)
        authService.signUp(credentials: credentials)
        signUpStatusSubscription = authService.$authStatus
            .sink {[weak self] fetchedStatus in
                self?.showProgressView = false
                if let fetchedStatus = fetchedStatus{
                    switch fetchedStatus{
                    case .authorizationError(let message):
                        self?.showCredentialsError = true
                        self?.errorMessage = message
                    case .ok:
                        self?.setPasscode = true
                        self?.signUpStatusSubscription?.cancel()
                    case .credentialsError:
                        print("")
                    }
                }
            }
    }
    
    func addPasscodeSubscription(passcodeVM: PasscodeViewModel){
        passcodeVM.$authSuccess
            .sink { [weak self] success in
                if success{
                    self?.navigateToProfileSetupView = true
                }
            }
            .store(in: &cancellables)
    }
}
