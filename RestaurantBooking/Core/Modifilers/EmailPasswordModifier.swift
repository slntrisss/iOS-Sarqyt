//
//  EmailPasswordModifier.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct EmailPasswordModifier: ViewModifier{
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.theme.field)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
