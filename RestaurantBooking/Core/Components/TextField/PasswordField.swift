//
//  PasswordField.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct PasswordField: View {
    @Binding var password: String
    @Binding var showPassword: Bool
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "lock.fill")
                    .foregroundColor(Color.theme.secondaryText)
                field
                showPasswordButton
            }
            .emailPasswordMode()
        }
    }
}

struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            PasswordField(password: .constant(""), showPassword: .constant(false))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
                .padding()
            
            PasswordField(password: .constant(""), showPassword: .constant(false))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .padding()
        }
    }
}

extension PasswordField{
    
    private var field: some View{
        ZStack{
            TextField("Password", text: $password)
                .opacity(showPassword ? 1.0 : 0.0)
            SecureField("Password", text: $password)
                .opacity(showPassword ? 0.0 : 1.0)
        }
    }
    
    private var showPasswordButton: some View{
        Button{
            showPassword.toggle()
        }label: {
            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                .foregroundColor(Color.theme.secondaryText)
        }
    }
}
