//
//  RememberMeToogle.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI
//square
struct RememberMeToogle: View {
    @Binding var rememberMe:Bool
    var body: some View {
        HStack{
            Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                .foregroundColor(Color.theme.green)
                .onTapGesture {
                    rememberMe.toggle()
                }
            Text("Remember me")
                .font(.caption)
                .fontWeight(.semibold)
        }
    }
}

struct RememberMeToogle_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            RememberMeToogle(rememberMe: .constant(true))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
                .padding()
            
            RememberMeToogle(rememberMe: .constant(false))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
