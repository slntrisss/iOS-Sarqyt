//
//  FilterPriceRangeView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 24.02.2023.
//

import SwiftUI

struct FilterPriceRangeView: View {
    @EnvironmentObject private var filterVM: FilterViewModel
    let paddingAmount: CGFloat
    
    var body: some View {
        VStack{
            FilterSectionHeaderView(label: "Price Range")
            HStack{
                fromView
                tillView
            }
            .padding(.vertical, paddingAmount)
            PriceSliderView(minPriceAmount: filterVM.minPriceAmount, maxPriceAmount: filterVM.maxPriceAmount, fromAmount: $filterVM.fromPriceAmount, tillAmount: $filterVM.tillPriceAmount, totalWidth: UIScreen.main.bounds.width-(paddingAmount*2))
        }
        .padding(paddingAmount)
    }
}

struct FilterPriceRangeView_Previews: PreviewProvider {
    static var previews: some View {
        FilterPriceRangeView(paddingAmount: 20)
            .environmentObject(FilterViewModel())
    }
}

extension FilterPriceRangeView{
    
    private var fromView: some View{
        HStack{
            Text("from:")
                .foregroundColor(Color.theme.secondaryText)
            TextField(value: $filterVM.fromPriceAmount, format: .number) {EmptyView()}
                .keyboardType(.numberPad)
                .font(.headline)
                .foregroundColor(Color.theme.accent.opacity(0.8))
                .onChange(of: filterVM.fromPriceAmount, perform: {_ in filterVM.validateRange()})
        }
        .padding(.vertical)
        .padding(.horizontal, 5)
        .background(
            RoundedRectangle(cornerRadius: 2)
                .stroke(Color.theme.secondaryText, lineWidth: 1)
        )
    }
    
    private var tillView: some View{
        HStack{
            Text("till:")
                .foregroundColor(Color.theme.secondaryText)
            TextField(value: $filterVM.tillPriceAmount, format: .number) {EmptyView()}
                .keyboardType(.numberPad)
                .font(.headline)
                .foregroundColor(Color.theme.accent.opacity(0.8))
                .onChange(of: filterVM.fromPriceAmount, perform: {_ in filterVM.validateRange()})
        }
        .padding(.vertical)
        .padding(.horizontal, 5)
        .background(
            RoundedRectangle(cornerRadius: 2)
                .stroke(Color.theme.secondaryText, lineWidth: 1)
        )
    }
}
