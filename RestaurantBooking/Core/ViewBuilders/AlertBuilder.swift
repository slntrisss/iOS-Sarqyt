//
//  AlertBuilder.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 17.02.2023.
//

import SwiftUI

struct AlertBuilder<Content: View>: View {
    let content: Content
    @Binding var showAlert: Bool
    init(showAlert: Binding<Bool>, @ViewBuilder content: () -> Content){
        self._showAlert = showAlert
        self.content = content()
    }
    var body: some View {
        ZStack(alignment: .center){
            if showAlert{
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                VStack{
                    content
                }
                .padding()
                .background(Color.theme.sheetBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
}
