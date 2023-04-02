//
//  SignUpViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 02.04.2023.
//

import Foundation

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
}
