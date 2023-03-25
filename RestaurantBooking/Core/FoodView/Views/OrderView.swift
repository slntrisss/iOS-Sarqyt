//
//  OrderedFoodsView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 23.03.2023.
//

import SwiftUI

struct OrderView: View {
    @StateObject private var orderVM: OrderViewModel
    init(orderedFoods: [OrderedFood], bookedRestaurant: Restaurant){
        self._orderVM = StateObject(wrappedValue: OrderViewModel(orderedFoods: orderedFoods, bookedRestaurant: bookedRestaurant))
    }
    var body: some View {
        ScrollView{
            LazyVStack{
                ForEach(orderVM.orderedFoods) { orderedFood in
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
            OrderView(orderedFoods: DeveloperPreview.instance.orderedFoods, bookedRestaurant: DeveloperPreview.instance.restaurant)
        }
    }
}
