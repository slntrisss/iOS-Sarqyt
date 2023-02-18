//
//  EmailField.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct EmailField: View {
    @Binding var email: String
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "envelope.fill")
                    .foregroundColor(Color.theme.secondaryText)
                TextField("Email", text: $email)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
            }
            .emailPasswordMode()
        }
    }
}

struct EmailField_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            EmailField(email: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
                .padding()
            
            EmailField(email: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .padding()
        }
    }
}
