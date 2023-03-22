//
//  FoodCardViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 22.03.2023.
//

import SwiftUI

class FoodCardViewModel: ObservableObject{
    @Published var orderedFood: OrderedFood
    @Published var showQuantityLabel: Bool = false
    init(food: Food){
        orderedFood = OrderedFood(id: UUID().uuidString, food: food, count: 1, price: food.price, specialWishes: "")
    }
    
    func displayQuantityLabel(){
        withAnimation(.easeInOut(duration: 0.4)) {
            showQuantityLabel = true
        }
    }
    
    func increaseQuantityButtonTapped(){
        orderedFood.count += 1
        orderedFood.price += orderedFood.food.price
    }
    
    func decreaseQuantityButtonTapped(){
        if orderedFood.count > 1{
            orderedFood.count -= 1
            orderedFood.price -= orderedFood.food.price
        }else{
            withAnimation(.easeInOut(duration: 0.4)) {
                showQuantityLabel = false
            }
        }
    }
}
