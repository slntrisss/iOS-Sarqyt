//
//  SignInView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct SignInView: View {
    @State private var signInWithPasswordButtonClicked = false
    @State private var signUpButtonClicked = false
    @Binding var isAuthenticated: Bool
    var body: some View {
        NavigationStack{
            VStack{
                VStack(){
                    Spacer()
                    signInButtons
                    
                    DividerWithText(text: "or")
                        .padding(.vertical, 40)
                    
                    PrimaryButton(buttonLabel: "Sign In With Password", buttonClicked: $signInWithPasswordButtonClicked)
                    
                    Spacer()
                    RegistrationBottomHelperButton(descriptionLabel: "Don't have an account?", buttonLabel: "Sign Up", buttonClicked: $signUpButtonClicked)
                }
                .padding()
            }
            .navigationTitle("Sign In")
            .navigationDestination(isPresented: $signUpButtonClicked) {SignUpView()}
            .navigationDestination(isPresented: $signInWithPasswordButtonClicked) {LoginView(isAuthenticated: $isAuthenticated)}
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(isAuthenticated: .constant(false))
            .preferredColorScheme(.dark)
    }
}

extension SignInView{
    
    private var signinWithMetaView: some View{
        HStack(spacing: 30){
            Button{
                
            }label: {
                Image("meta-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                Text("Continue with Meta")
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.secondaryText, lineWidth: 0.5)
        )
    }
    
    private var signinWithGoogleView: some View{
        HStack(spacing: 30){
            Button{
                
            }label: {
                Image("google-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                Text("Continue with Google")
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.secondaryText, lineWidth: 0.5)
        )
    }
    
    private var signinWithAppleView: some View{
        HStack(spacing: 30){
            Button{
                
            }label: {
                Image("apple-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                Text("Continue with Apple")
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.theme.secondaryText, lineWidth: 0.5)
        )
    }
    
    private var signInButtons: some View{
        VStack{
            signinWithMetaView
            signinWithGoogleView
            signinWithAppleView
        }
    }
}
