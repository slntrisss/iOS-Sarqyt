//
//  LoginView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var vm = LoginViewModel()
    
    @State private var rememberMe = false
    
    @State private var forgotPasswordButtonClicked = false
    
    @State private var signInWithGoogleTapped = false
    @State private var signInWithMetaTapped = false
    @State private var signInWithAppleTapped = false
    
    @State private var showPassword = false
    
    var body: some View {
        ZStack{
            ScrollView(.vertical, showsIndicators: false){
                Text("Login To Your Account")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.accent)
                    .padding(.top, 100)
                
                VStack(spacing: 20){
                    EmailField(email: $vm.credentials.email)
                    PasswordField(password: $vm.credentials.password, showPassword: $showPassword)
                }
                
                HStack{
                    RemembeMeToggle(isOn: $rememberMe)
                    Spacer()
                }
                .padding(.vertical)
                
                PrimaryButton(buttonLabel: "Sign In", buttonClicked: $vm.signInButtonTapped)
                    .padding(.bottom, 10)
                    .onChange(of: vm.signInButtonTapped) { _ in vm.signIn()}
                
                forgotPasswordButton
                
                bottomViewButtons
            }
            .padding()
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $forgotPasswordButtonClicked) {ResetTypeView()}
            ProcessingView(showProcessingView: $vm.showProcessingView)
            credentialsNotProvidedError
        }
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
    
    private var credentialsNotProvidedError: some View{
        AlertBuilder(showAlert: $vm.showCredentialsError) {
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
                
                Text(vm.error?.localizedDescription ?? "")
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                
                Divider()
                
                Button{
                    vm.showCredentialsError = false
                }label: {
                    Text("Dismiss")
                        .foregroundColor(.blue)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.6)
        }
        .animation(.default, value: vm.showCredentialsError)
    }
}
