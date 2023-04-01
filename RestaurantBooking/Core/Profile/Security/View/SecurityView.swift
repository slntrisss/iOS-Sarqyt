//
//  SecurityView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 02.04.2023.
//

import SwiftUI

struct SecurityView: View {
    @StateObject private var securityVM = SecurityViewModel()
    var body: some View {
        VStack(spacing: 20){
            createNavLinkField(text: "Change password")
            HStack{
                Text("Face ID")
                Toggle("", isOn: $securityVM.faceIdEnbaled)
            }
            .opacity(securityVM.supportsFaceID ? 1.0 : 0.0)
            HStack{
                Text("Touch ID")
                Toggle("", isOn: $securityVM.touchIdEnabled)
            }
            .opacity(securityVM.supportsTouchID ? 1.0 : 0.0)
            Spacer()
        }
        .font(.headline)
        .padding(.horizontal)
        .padding(.top, 30)
        .navigationDestination(isPresented: $securityVM.changePassword, destination: {
            NewPasswordView()
        })
        .navigationTitle("Security")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SecurityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SecurityView()
        }
    }
}
extension SecurityView{
    private func createNavLinkField(text: String) -> some View{
        HStack{
            Text(text)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .onTapGesture {
            securityVM.changePassword = true
        }
    }
}
