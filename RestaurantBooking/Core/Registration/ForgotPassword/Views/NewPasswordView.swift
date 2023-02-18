//
//  NewPasswordView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.02.2023.
//

import SwiftUI

struct NewPasswordView: View {
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var rememberMe = false
    @State private var continueButtonTapped = false
    @State private var showPasswordErrorAlert = false
    @State private var alertOffset = -10.0
    
    @State private var showPassword = false
    
    var body: some View {
        ZStack{
            ScrollView(.vertical, showsIndicators: false){
                contentImageView
                
                VStack{
                    HStack{
                        Text("Create Your New Password")
                            .foregroundColor(Color.theme.secondaryText)
                        Spacer()
                    }
                    
                    inputFields
                    
                    HStack{
                        RememberMeToogle(rememberMe: $rememberMe)
                        Spacer()
                    }
                    
                    PrimaryButton(buttonLabel: "Continue", buttonClicked: $continueButtonTapped)
                        .onChange(of: continueButtonTapped) { newValue in
                            checkForPasswordEquality()
                        }
                }
            }
            .padding()
            .navigationTitle("Create New Password")
            .navigationBarTitleDisplayMode(.inline)
            
            passwordsNotIdenticalError
        }
    }
}

struct NewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            NewPasswordView()
        }
    }
}

extension NewPasswordView{
    
    private func checkForPasswordEquality(){
        if password != confirmPassword{
            withAnimation {
                showPasswordErrorAlert = true
            }
            alertOffset = 0.0
        }
    }
    
    private var contentImageView: some View{
        Image("shield")
            .resizable()
            .scaledToFit()
            .foregroundColor(Color.theme.green)
            .frame(width: 300, height: 300)
            .shadow(color: .black.opacity(0.3), radius: 10, x: 5, y: 10)
    }
    
    private var inputFields: some View{
        VStack(spacing: 20){
            PasswordField(password: $password, showPassword: $showPassword)
            PasswordConfirmField(password: $confirmPassword, showPassword: $showPassword)
        }
        .padding(.bottom)
    }
    
    private var passwordsNotIdenticalError: some View{
        AlertBuilder(showAlert: $showPasswordErrorAlert) {
            VStack(spacing: 20){
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .foregroundColor(.yellow)
                    .frame(width: 40, height: 40)
                    .offset(x: alertOffset)
                    .animation(.default.repeatCount(5).speed(4), value: alertOffset)
                
                Text("Password Error")
                    .foregroundColor(Color.theme.accent)
                
                Text("Provided passwords do not match. Please try again.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.theme.secondaryText)
                
                Divider()
                
                Button{
                    withAnimation {
                        showPasswordErrorAlert = false
                    }
                    alertOffset = -10.0
                }label: {
                    Text("OK")
                        .foregroundColor(.blue)
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
        }
    }
}
