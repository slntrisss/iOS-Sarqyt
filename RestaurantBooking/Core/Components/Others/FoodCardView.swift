//
//  FoodCard.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.03.2023.
//

import SwiftUI

struct FoodCardView: View {
    let food: Food
    @State private var orderButtonTapped: Bool = true
    @State private var count = 1
    @State private var showQuantityLabel = false
    var body: some View {
        content
            .frame(width: 130)
            .padding()
            .overlay(quantityLabelView,alignment: .topLeading)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.theme.secondaryButton))
            .shadow(radius: 5)
    }
}

struct FoodCard_Previews: PreviewProvider {
    static var previews: some View {
        FoodCardView(food: DeveloperPreview.instance.food)
            .previewLayout(.sizeThatFits)
    }
}

extension FoodCardView{
    
    private var content: some View{
        VStack{
            Image(food.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .shadow(radius: 4)
            Text(food.name)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Button{
                
            }label: {
                Text("₸\(food.price)")
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.theme.green)
        }
    }
    
    private var quantityLabelView: some View{
        Circle()
            .fill(Color.theme.green)
            .frame(width: 30, height: 30)
            .overlay(
                Text("\(count)x")
                    .font(.headline)
                    .foregroundColor(.white)
            )
            .offset(x: -10, y: -10)
            .opacity(showQuantityLabel ? 1.0 : 0.0)
    }
}
