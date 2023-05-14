//
//  SchemeView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 08.04.2023.
//

import SwiftUI

struct SchemeView: View {
    @ObservedObject var schemeVM: SchemeViewModel
    @State private var currentAmount: CGFloat = 0
    @State private var lastAmount: CGFloat = 0
    @State private var currentOffset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    @Binding var numberOfGuests: Int
    @Binding var selectedTimeInterval: String
    let restaurantId: String
    let selectedDate: Date
    init(schemeVM: SchemeViewModel, restaurantId: String, selectedDate: Date,
         numberOfGuests: Binding<Int>, selectedTimeInterval: Binding<String>){
        self.schemeVM = schemeVM
        self.restaurantId = restaurantId
        self.selectedDate = selectedDate
        self._numberOfGuests = numberOfGuests
        self._selectedTimeInterval = selectedTimeInterval
    }
    var body: some View {
        LazyVStack{
            ScrollView(.horizontal){
                HStack{
                    ForEach(schemeVM.scheme?.floors.indices ?? 0..<0, id: \.self){ index in
                        Button{
                            schemeVM.floorNumberTapped(at: index)
                        }label: {
                            Text(schemeVM.floorNumberFor(index: index))
                                .font(.headline)
                                .foregroundColor(schemeVM.forgroundColorForButton(at: index))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 12)
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(schemeVM.backgroundColorForButton(at: index)))
                        }
                    }
                }
            }
            .padding(.horizontal)
            ZStack{
                if schemeVM.schemeIsLoading{
                    ProgressView()
                }else{
                    ZStack{ scheme }
                        .offset(currentOffset)
                        .scaleEffect(1 + schemeVM.currentScaleAmount + lastAmount)
                        .contentShape(Rectangle())
                        .gesture(dragGesture)
                        .gesture(magnificationGesture)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 380)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Color.theme.secondaryText.opacity(0.5), lineWidth: 3)
            )
            .padding(.horizontal, 20)
            .sheet(isPresented: $schemeVM.showTableInfoSheet) {
                TableInfoView(schemeVM: schemeVM, selectedTime: $selectedTimeInterval, numberOfGuests: $numberOfGuests)
                    .presentationDetents([.fraction(0.8), .large])
            }
        }
        .onAppear{
            schemeVM.setupRestaurantScheme()
        }
    }
}

struct SchemeView_Previews: PreviewProvider {
    static var previews: some View {
        SchemeView(schemeVM: SchemeViewModel(restaurantId: dev.restaurant.id),
                   restaurantId: "", selectedDate: Date(), numberOfGuests: .constant(0), selectedTimeInterval: .constant(""))
    }
}

extension SchemeView{
    
    private var scheme: some View{
        Group{
            if let scheme = schemeVM.scheme{
                ForEach(0..<scheme.floors[schemeVM.selectedFloor].groups.count, id: \.self) { index in
                    GroupView(
                        mapItemGroup:scheme.floors[schemeVM.selectedFloor].groups[index],
                        isSelected: $schemeVM.mapItemGroupSelectOptions[index]
                    )
                    .onTapGesture {
                        let groupId = scheme.floors[schemeVM.selectedFloor].groups[index].id
                        if schemeVM.selectedIndex != index{
                            numberOfGuests = 1
                            selectedTimeInterval = ""
                        }
                        schemeVM.getTablePhotos(with: restaurantId, selectedDate: selectedDate, groupId: groupId, index: index)
                    }
                }
            }else{
                EmptyView()
            }
        }
    }
    
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
    
    private var dragGesture: some Gesture{
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
    }
}
