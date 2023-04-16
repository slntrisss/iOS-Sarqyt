//
//  SchemeView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 08.04.2023.
//

import SwiftUI

struct SchemeView: View {
    @StateObject private var schemeVM = SchemeViewModel()
    @State private var currentAmount: CGFloat = 0
    @State private var lastAmount: CGFloat = 0
    @State private var currentOffset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
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
        .offset(currentOffset)
        .scaleEffect(1 + currentAmount + lastAmount)
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged{ value in
                    withAnimation(.easeInOut(duration: 0.5)){
                        currentOffset = value.translation
                    }
                }
                .onEnded{ value  in
                    withAnimation(.easeInOut(duration: 0.5)){
                        currentOffset = value.translation
                    }
                }
        )
        .gesture(magnificationGesture)
    }
}

struct SchemeView_Previews: PreviewProvider {
    static var previews: some View {
        SchemeView()
    }
}

extension SchemeView{
    private var magnificationGesture: some Gesture{
        MagnificationGesture()
            .onChanged{ value in
                currentAmount = value - 1
            }
            .onEnded{ value in
                lastAmount += currentAmount
                currentAmount = 0
            }
    }
}
