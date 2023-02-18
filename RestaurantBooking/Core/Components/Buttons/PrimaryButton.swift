//
//  PrimaryButton.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct PrimaryButton: View {
    let buttonLabel: String
    @Binding var buttonClicked: Bool
    var body: some View {
        VStack{
            Button{
                buttonClicked.toggle()
            }label: {
                Text(buttonLabel)
                    .font(.headline)
                    .foregroundColor(Color.theme.primaryButton)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.green)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.theme.green.opacity(0.5), radius: 5, x: 0, y: 5)
            }
        }
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            PrimaryButton(buttonLabel: "buttonLabel", buttonClicked: .constant(false))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
                .padding()
            
            PrimaryButton(buttonLabel: "buttonLabel", buttonClicked: .constant(false))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .padding()
        }
    }
}
