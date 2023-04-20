//
//  ConfirmLoadingView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.04.2023.
//

import SwiftUI

struct ConfirmLoadingView: View {
    @Binding var showCheckmark: Double
    var body: some View {
        VStack{
            ProgressView()
                .opacity(showCheckmark < 0 ? 1.0 : 0.0)
                .offset(y: 30)
            Image(systemName: "checkmark")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.green)
                .clipShape(Rectangle().offset(x: showCheckmark))
                .animation(.spring(blendDuration: 2), value: showCheckmark)
                .padding(.bottom, 5)
            Text(showCheckmark < 0 ? "Processing..." : "Success!")
                .foregroundColor(showCheckmark < 0 ? Color.theme.accent : Color.theme.green)
        }
        .frame(width: 200, height: 150)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
    }
}

struct ConfirmLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmLoadingView(showCheckmark: .constant(-60))
    }
}
