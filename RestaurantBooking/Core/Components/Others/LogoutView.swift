//
//  LogoutView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 02.04.2023.
//

import SwiftUI

struct LogoutView: View {
    @Binding var logout: Bool
    @Binding var cancel: Bool
    var body: some View {
        VStack{
            Capsule()
                .fill(Color.theme.secondaryText.opacity(0.5))
                .frame(width: 40, height: 5)
            Text("Logout")
                .font(.title2.weight(.semibold))
                .foregroundColor(.red)
            Divider()
            Text("Are you sure you want to log out?")
                .font(.headline)
            Spacer().frame(height: 30)
            VStack(spacing: 20){
                PrimaryButton(buttonLabel: "Yes, Logout", buttonClicked: $logout)
                SecondaryButton(buttonLabel: "Cancel", buttonClicked: $cancel)
            }.padding(.horizontal)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 30).fill(Color.theme.sheetBackground))
        .presentationDetents([.height(300)])
    }
}

struct LogoutView_Previews: PreviewProvider {
    static var previews: some View {
        LogoutView(logout: .constant(false), cancel: .constant(false))
    }
}
