//
//  FoodDetailView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 22.03.2023.
//

import SwiftUI

struct FoodDetailView: View {
    let food: Food
    @ObservedObject var foodCardVM: FoodCardViewModel
    @State private var addButtonTapped = false
    var body: some View {
        VStack{
            foodImageView
                .padding(.vertical)
            ScrollView{
                contentView
                Spacer()
                bottomBar
            }
        }
        .presentationDetents([.large])
    }
}

struct FoodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailView(food: DeveloperPreview.instance.food, foodCardVM: FoodCardViewModel(food: DeveloperPreview.instance.food, bookVM: BookViewModel(restaurant: dev.restaurant)))
    }
}

extension FoodDetailView{
    
    private var foodImageView: some View{
        Image(uiImage: food.wrappedImage)
            .resizable()
            .scaledToFit()
            .frame(width: UIScreen.main.bounds.width * 0.5)
    }
    
    private var contentView: some View{
        VStack(alignment: .leading, spacing: 10){
            Text(food.name)
                .font(.headline)
            Text(food.description)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text("Special Wishes")
                .font(.subheadline)
                .padding(.top)
            TextEditor(text: $foodCardVM.specialWishes)
                .padding()
                .foregroundColor(Color.theme.secondaryText)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.theme.secondaryText.opacity(0.2), lineWidth: 1))
                .frame(height: 100)
        }
        .padding(.horizontal, 20)
    }
    
    private var bottomBar: some View{
        HStack{
            HStack{
                Button{
                    foodCardVM.decreaseDetailViewCount()
                }label: {
                    Image(systemName: "minus")
                        .foregroundColor(Color.theme.green)
                }
                .frame(width: 40)
                Text("\(foodCardVM.detailFoodCount)")
                    .font(.headline)
                    .frame(width: 40)
                Button{
                    foodCardVM.increaseDetailViewCount()
                }label: {
                    Image(systemName: "plus")
                        .foregroundColor(Color.theme.green)
                        .contentShape(Rectangle())
                }
                .frame(width: 40)
            }
            .frame(width: 120)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.theme.secondaryButton))
            Button{
                foodCardVM.addChangesButtonTapped()
            }label: {
                Text("Add")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.theme.green))
            }
        }
        .padding(.horizontal)
    }
}
