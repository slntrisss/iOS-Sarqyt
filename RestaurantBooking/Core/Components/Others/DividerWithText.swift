//
//  DividerWithText.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct DividerWithText: View {
    let text: String
    var body: some View {
        HStack{
            Rectangle()
                .fill(Color.theme.secondaryText)
                .frame(maxWidth: .infinity, maxHeight: 0.5)
            Text(text)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Rectangle()
                .fill(Color.theme.secondaryText)
                .frame(maxWidth: .infinity, maxHeight: 0.5)
        }
    }
}

struct DividerWithText_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            DividerWithText(text: "or")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
                .padding()
            DividerWithText(text: "or continue with")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .padding()
        }
    }
}
