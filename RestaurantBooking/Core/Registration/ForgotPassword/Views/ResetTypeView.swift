//
//  ResetTypeView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 17.02.2023.
//

import SwiftUI

struct ResetTypeView: View {
    @State private var continueButtonTapped = false
    @State private var resetViaSMS = false
    @State private var resetViaEmail = false
    @State private var showPasswordResetAlert = false
    var body: some View {
        ZStack{
            VStack{
                Image("lock")
                    .resizable()
                    .scaledToFit()
                resetDescriptionView
                VStack(alignment: .leading){
                    
                    resetViaSMSView
                    
                    resetViaEmailView
                    
                    PrimaryButton(buttonLabel: "Continue", buttonClicked: $continueButtonTapped)
                        .padding(.vertical)
                }
                NavigationLink(isActive: $continueButtonTapped) { CodeVerificationView()} label: { EmptyView() }
            }
            .padding()
            .navigationTitle("Forgot password")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: continueButtonTapped, perform: { newValue in
                if !resetViaSMS && !resetViaEmail{
                    withAnimation {
                        showPasswordResetAlert = true
                    }
                }
            })
            resetPasswordAlert
        }
    }
}

struct ResetTypeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ResetTypeView()
        }
    }
}

extension ResetTypeView{
    
    private var resetDescriptionView: some View{
        HStack{
            Text("Select which contact details should we use to reset rout password")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Spacer()
        }
    }
    
    private var resetViaSMSView: some View{
        HStack(spacing: 30){
            Image(systemName: "message.fill")
                .foregroundColor(Color.theme.green)
                .frame(width: 20, height: 20)
                .padding()
                .background(Color.theme.secondaryButton)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Via SMS")
                Text("+7••••••••94")
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(resetViaSMS ? Color.theme.green : Color.theme.secondaryText, lineWidth: resetViaSMS ? 2 : 0.5)
                .contentShape(Rectangle())
        )
        .onTapGesture {
            resetViaEmail = false
            resetViaSMS = true
        }
    }
    
    private var resetViaEmailView: some View{
        HStack(spacing: 30){
            Image(systemName: "envelope.fill")
                .foregroundColor(Color.theme.green)
                .frame(width: 20, height: 20)
                .padding()
                .background(Color.theme.secondaryButton)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Via Email")
                Text("mer••••••••@mail.ru")
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(resetViaEmail ? Color.theme.green : Color.theme.secondaryText, lineWidth: resetViaEmail ? 2 : 0.5)
                .contentShape(Rectangle())
        )
        .onTapGesture {
            resetViaEmail = true
            resetViaSMS = false
        }
    }
    
    private var resetPasswordAlert: some View {
        AlertBuilder(showAlert: $showPasswordResetAlert) {
            VStack(spacing: 20){
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.yellow)
                
                Text("Password reset error!")
                    .foregroundColor(Color.theme.accent)
                
                Text("Please select one of the option to reset your password")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.theme.secondaryText)
                Divider()
                Button{
                    withAnimation {
                        showPasswordResetAlert = false
                    }
                }label: {
                    Text("OK")
                        .foregroundColor(.blue)
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
        }
    }
}
