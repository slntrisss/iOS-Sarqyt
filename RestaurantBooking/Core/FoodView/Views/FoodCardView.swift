//
//  FoodCard.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.03.2023.
//

import SwiftUI

struct FoodCardView: View {
    @ObservedObject private var bookVM: BookViewModel
    @StateObject private var foodCardVM: FoodCardViewModel
    let food: Food
    init(food: Food, bookVM: BookViewModel){
        self.food = food
        self._bookVM = ObservedObject(wrappedValue: bookVM)
        self._foodCardVM = StateObject(wrappedValue: FoodCardViewModel(food: food, bookVM: bookVM))
    }
    var body: some View {
        content
            .frame(width: 130)
            .padding()
            .overlay(quantityLabelView,alignment: .topLeading)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.theme.secondaryButton))
            .shadow(radius: 5)
            .onTapGesture {foodCardVM.showDetail.toggle()}
            .sheet(isPresented: $foodCardVM.showDetail) {FoodDetailView(food: food, foodCardVM: foodCardVM)}
    }
}

struct FoodCard_Previews: PreviewProvider {
    static var previews: some View {
        FoodCardView(food: DeveloperPreview.instance.food, bookVM: BookViewModel())
            .environmentObject(BookViewModel())
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
            if foodCardVM.showQuantityLabel{
                HStack{
                    Button{
                        foodCardVM.decreaseQuantityButtonTapped()
                    }label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(Color.theme.green)
                    }
                    Text(foodCardVM.orderedFood.price.toKZTCurrency())
                        .font(.headline)
                        .foregroundColor(Color.theme.accent)
                        .lineLimit(1)
                        .font(.caption)
                        .minimumScaleFactor(0.5)
                    Button{
                        foodCardVM.increaseQuantityButtonTapped()
                    }label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color.theme.green)
                    }
                }
                .padding(.top)
            }else{
                Button{
                    foodCardVM.displayQuantityLabel()
                }label: {
                    Text(food.price.toKZTCurrency())
                }
                .opacity(foodCardVM.showQuantityLabel ? 0.0 : 1.0)
                .buttonStyle(.borderedProminent)
                .tint(Color.theme.green)
            }
        }
    }
    
    private var quantityLabelView: some View{
        Circle()
            .fill(Color.theme.green)
            .frame(width: 40, height: 40)
            .overlay(
                Text("\(foodCardVM.orderedFood.count)x")
                    .font(.headline)
                    .foregroundColor(.white)
            )
            .offset(x: -10, y: -10)
            .opacity(foodCardVM.showQuantityLabel ? 1.0 : 0.0)
    }
}
