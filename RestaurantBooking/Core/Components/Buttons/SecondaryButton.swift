//
//  SecondaryButton.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 23.02.2023.
//

import SwiftUI

struct SecondaryButton: View {
    let buttonLabel: String
    @Binding var buttonClicked: Bool
    var body: some View {
        VStack{
            Button{
                buttonClicked.toggle()
            }label: {
                Text(buttonLabel)
                    .font(.headline)
                    .foregroundColor(Color.theme.secondaryButtonText)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.secondaryButton)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
}

struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SecondaryButton(buttonLabel: "Cancel", buttonClicked: .constant(false))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
                .padding()
            
            SecondaryButton(buttonLabel: "Cancel", buttonClicked: .constant(false))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .padding()
        }
    }
}
