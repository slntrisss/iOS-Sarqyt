//
//  FilterSectionHeader.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 24.02.2023.
//

import SwiftUI

struct FilterSectionHeaderView: View {
    let label: String
    let buttonLabel: String?
    @Binding var buttonTapped: Bool
    init(label: String,
         buttonLabel: String? = nil,
         buttonTapped: Binding<Bool> = .constant(false)) {
        self.label = label
        self.buttonLabel = buttonLabel
        self._buttonTapped = buttonTapped
    }
    var body: some View {
        HStack{
            Text(label)
                .font(.headline.weight(.semibold))
            Spacer()
            if let buttonLabel = buttonLabel{
                Button{
                    buttonTapped.toggle()
                }label: {
                    Text(buttonLabel)
                        .font(.caption)
                        .foregroundColor(Color.theme.green)
                }
            }
        }
    }
}

struct FilterSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FilterSectionHeaderView(label: "Country", buttonLabel: "See All")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
                .padding()
            
            FilterSectionHeaderView(label: "Country", buttonLabel: "See All")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .padding()
        }
    }
}
