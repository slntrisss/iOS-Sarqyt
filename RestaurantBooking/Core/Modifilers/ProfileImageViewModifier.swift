//
//  ProfileImageViewModifier.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct ProfileImageViewModifier: ViewModifier{
    func body(content: Content) -> some View {
        content
            .overlay(
            RoundedRectangle(cornerRadius: 10)
                .fill(.green)
                .frame(width: 30, height: 30)
                .overlay(
                    Image(systemName: "square.and.pencil")
                        .font(.body.weight(.heavy))
                        .foregroundColor(.white)
                ),
            alignment: .bottomTrailing)
    }
}
