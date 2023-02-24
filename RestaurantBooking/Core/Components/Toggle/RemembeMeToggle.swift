//
//  RememberMeToogle.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI
//square
struct RemembeMeToggle: View {
    @Binding var isOn:Bool
    var body: some View {
        HStack{
            Image(systemName: isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(Color.theme.green)
                .onTapGesture {
                    isOn.toggle()
                }
            Text("Remember Me")
                .font(.caption)
                .fontWeight(.semibold)
        }
    }
}

struct RememberMeToogle_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            RemembeMeToggle(isOn: .constant(true))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
                .padding()
            
            RemembeMeToggle(isOn: .constant(false))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
