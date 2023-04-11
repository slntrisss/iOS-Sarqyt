//
//  SchemeView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 08.04.2023.
//

import SwiftUI

struct SchemeView: View {
    @StateObject private var schemeVM = SchemeViewModel()
    
    var body: some View {
        ZStack{
            ForEach(0..<schemeVM.scheme.floors[schemeVM.selectedFloor].groups.count, id: \.self) { index in
                GroupView(
                    mapItemGroup:schemeVM.scheme.floors[schemeVM.selectedFloor].groups[index],
                    isSelected: $schemeVM.mapItemGroupSelectOptions[index]
                )
                .onTapGesture {
                    schemeVM.groupItemTapped(at: index)
                    print("Tapped \(schemeVM.selectedIndex)")
                }
            }
        }
        .offset(x: 10)
    }
}

struct SchemeView_Previews: PreviewProvider {
    static var previews: some View {
        SchemeView()
    }
}
