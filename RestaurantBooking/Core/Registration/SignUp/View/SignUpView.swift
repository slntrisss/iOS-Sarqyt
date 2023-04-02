//
//  SignUpView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var signUpVM = SignUpViewModel()
    
    var body: some View {
        ScrollView{
            title
    
            fields
                .padding(.vertical)
            
            HStack{
                RemembeMeToggle(isOn: $signUpVM.rememberMe)
                Spacer()
            }
            
            PrimaryButton(buttonLabel: "Sign Up", buttonClicked: $signUpVM.signUpButtonClicked)
                .padding(.vertical)
            
            DividerWithText(text: "or continue with")
                .padding(.vertical)
            
            SignInWithView(signInWithGoogleTapped: $signUpVM.signInWithGoogleTapped, signInWithMetaTapped: $signUpVM.signInWithMetaTapped, signInWithAppleTapped: $signUpVM.signInWithAppleTapped)
            
            
        }
        .padding()
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            SignUpView()
        }
    }
}

extension SignUpView{
    
    private var title: some View{
        Text("Create your Account")
            .font(.title)
            .fontWeight(.semibold)
            .padding(.top, 100)
    }
    
    private var fields: some View{
        VStack(spacing: 20){
            EmailField(email: $signUpVM.email)
            PasswordField(password: $signUpVM.password, showPassword: $signUpVM.showPassword)
            PasswordConfirmField(password: $signUpVM.confirmPassword, showPassword: $signUpVM.showPassword)
        }
    }
}
