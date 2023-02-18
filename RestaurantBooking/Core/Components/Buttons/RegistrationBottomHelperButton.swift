//
//  RegistrationBottomHelperButton.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct RegistrationBottomHelperButton: View {
    let descriptionLabel: String
    let buttonLabel: String
    @Binding var buttonClicked: Bool
    var body: some View {
        HStack{
            Text(descriptionLabel)
                .foregroundColor(Color.theme.secondaryText)
            Button{
                buttonClicked = true
            }label: {
                Text(buttonLabel)
                    .font(.caption)
                    .foregroundColor(Color.theme.green)
            }
        }
        .font(.caption)
    }
}

struct RegistrationBottomHelperButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RegistrationBottomHelperButton(descriptionLabel: "Don't have an account?", buttonLabel: "Sign Up", buttonClicked: .constant(false))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
                .padding()
            
            RegistrationBottomHelperButton(descriptionLabel: "Don't have an account?", buttonLabel: "Sign Up", buttonClicked: .constant(false))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
