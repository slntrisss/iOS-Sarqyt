//
//  SignUpView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var rememberMe = false
    @State private var signUpButtonClicked = false
    
    @State private var signInWithGoogleTapped = false
    @State private var signInWithMetaTapped = false
    @State private var signInWithAppleTapped = false
    
    var body: some View {
        ScrollView{
            title
    
            fields
                .padding(.vertical)
            
            HStack{
                RememberMeToogle(rememberMe: $rememberMe)
                Spacer()
            }
            
            PrimaryButton(buttonLabel: "Sign Up", buttonClicked: $signUpButtonClicked)
                .padding(.vertical)
            
            DividerWithText(text: "or continue with")
                .padding(.vertical)
            
            SignInWithView(signInWithGoogleTapped: $signInWithGoogleTapped, signInWithMetaTapped: $signInWithMetaTapped, signInWithAppleTapped: $signInWithAppleTapped)
            
            
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
            EmailField(email: $email)
            PasswordField(password: $password)
            PasswordConfirmField(password: $confirmPassword)
        }
    }
}
