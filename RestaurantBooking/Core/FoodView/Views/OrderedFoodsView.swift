//
//  OrderedFoodsView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 23.03.2023.
//

import SwiftUI

struct OrderedFoodsView: View {
    @StateObject private var orderedFoodVM: OrderedFoodViewModel
    init(orderedFoods: [OrderedFood]){
        self._orderedFoodVM = StateObject(wrappedValue: OrderedFoodViewModel(orderedFoods: orderedFoods))
    }
    var body: some View {
        ScrollView{
            LazyVStack{
                ForEach(orderedFoodVM.orderedFoods) { orderedFood in
                    HStack{
                        Image(orderedFood.food.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                        VStack(alignment: .leading, spacing: 5){
                            Text(orderedFood.food.name)
                                .font(.subheadline)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                            Text(orderedFood.price.toKZTCurrency())
                                .font(.caption.weight(.semibold))
                            HStack(spacing: 20){
                                Button{
                                    
                                }label: {
                                    Image(systemName: "minus")
                                        .foregroundColor(Color.theme.accent)
                                }
                                Text("\(orderedFood.count)")
                                Button{
                                    
                                }label: {
                                    Image(systemName: "plus")
                                        .foregroundColor(Color.theme.accent)
                                        .contentShape(Rectangle())
                                }
                            }
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.theme.secondaryText.opacity(0.2)))
                        }
                    }
                    Divider()
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Order")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button{
                    
                }label: {
                    Image(systemName: "xmark")
                        .font(.headline)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "trash")
                    .font(.headline)
            }
        }
    }
}

struct OrderedFoodsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            OrderedFoodsView(orderedFoods: DeveloperPreview.instance.orderedFoods)
        }
    }
}
