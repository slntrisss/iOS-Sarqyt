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
            Divider()
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
        .contentShape(Rectangle())
        .onTapGesture {
            securityVM.changePassword = true
        }
    }
}
