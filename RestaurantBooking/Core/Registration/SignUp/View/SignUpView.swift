//
//  SignUpView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var signUpVM = SignUpViewModel()
    @StateObject private var passcodeVM = PasscodeViewModel(type: .createdPasscode)
    @Binding var isAuthenticated: Bool
    var body: some View {
        ZStack{
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
                    .onChange(of: signUpVM.signUpButtonClicked) { _ in
                        signUpVM.signUp()
                    }
                
                DividerWithText(text: "or continue with")
                    .padding(.vertical)
                
                SignInWithView(signInWithGoogleTapped: $signUpVM.signInWithGoogleTapped, signInWithMetaTapped: $signUpVM.signInWithMetaTapped, signInWithAppleTapped: $signUpVM.signInWithAppleTapped)
                
                
            }
            .padding()
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.inline)
            ProcessingView(showProcessingView: $signUpVM.showProgressView)
            credentialsNotProvidedError
        }
        .onAppear{
            signUpVM.addPasscodeSubscription(passcodeVM: passcodeVM)
        }
        .navigationDestination(isPresented: $signUpVM.navigateToProfileSetupView) {
            ProfileSetupView(isAuthenticated: $isAuthenticated)
        }
        .fullScreenCover(isPresented: $signUpVM.setPasscode) {
            NumberPadView(passcodeVM: passcodeVM)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            SignUpView(isAuthenticated: .constant(false))
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
    
    private var credentialsNotProvidedError: some View{
        AlertBuilder(showAlert: $signUpVM.showCredentialsError) {
            VStack(spacing: 20){
                
                Image(systemName: "xmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.red)
                
                Text("Credentials error")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.accent)
                
                Text(signUpVM.errorMessage)
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                
                Divider()
                
                Button{
                    signUpVM.showCredentialsError = false
                }label: {
                    Text("Dismiss")
                        .foregroundColor(.blue)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.6)
        }
        .animation(.default, value: signUpVM.showCredentialsError)
    }
}
