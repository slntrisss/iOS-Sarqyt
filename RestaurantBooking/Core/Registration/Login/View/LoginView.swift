//
//  LoginView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var signInButtonClicked = false
    @State private var signUpButtonClicked = false
    @State private var forgotPasswordButtonClicked = false
    
    @State private var signInWithGoogleTapped = false
    @State private var signInWithMetaTapped = false
    @State private var signInWithAppleTapped = false
    
    @State private var showPassword = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            Text("Login To Your Account")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(Color.theme.accent)
                .padding(.top, 100)
            
            VStack(spacing: 20){
                EmailField(email: $email)
                PasswordField(password: $password, showPassword: $showPassword)
            }
            
            HStack{
                RememberMeToogle(rememberMe: $rememberMe)
                Spacer()
            }
            .padding(.vertical)
            
            PrimaryButton(buttonLabel: "Sign In", buttonClicked: $signInButtonClicked)
                .padding(.bottom, 10)
            
            forgotPasswordButton
                .background(
                    NavigationLink(isActive: $forgotPasswordButtonClicked,
                                   destination: {ResetTypeView()},
                                   label: {EmptyView()}))
            
            bottomViewButtons
        }
        .background(
            NavigationLink(isActive: $signUpButtonClicked, destination: {
                SignUpView()
            }, label: {
                EmptyView()
            })
        )
        .padding()
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            LoginView()
        }
    }
}

extension LoginView{
    
    private var bottomViewButtons: some View{
        VStack{
            DividerWithText(text: "or continue with")
                .padding(.top, 30)
            
            SignInWithView(signInWithGoogleTapped: $signInWithGoogleTapped, signInWithMetaTapped: $signInWithMetaTapped, signInWithAppleTapped: $signInWithAppleTapped)
                .padding(.vertical)
        }
    }
    
    private var forgotPasswordButton: some View{
        Button{
            forgotPasswordButtonClicked = true
        }label: {
            Text("Forgot Password?")
                .font(.callout)
                .foregroundColor(Color.theme.green)
        }
    }
}
