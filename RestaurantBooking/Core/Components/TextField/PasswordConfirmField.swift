//
//  PasswordConfirm.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct PasswordConfirmField: View {
    @Binding var password: String
    @State private var showPassword = false
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "lock.fill")
                    .foregroundColor(Color.theme.secondaryText)
                field
            }
            .emailPasswordMode()
        }
    }
}

struct PasswordConfirm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PasswordConfirmField(password: .constant(""))
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            PasswordConfirmField(password: .constant(""))
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension PasswordConfirmField{
    private var field: some View{
        ZStack{
            TextField("Confirm password", text: $password)
                .opacity(showPassword ? 1.0 : 0.0)
            SecureField("Confirm password", text: $password)
                .opacity(showPassword ? 0.0 : 1.0)
        }
    }
}
