//
//  FoodCardViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 22.03.2023.
//

import SwiftUI

class FoodCardViewModel: ObservableObject{
    @Published var orderedFood: OrderedFood
    @Published var foodVM: FoodViewModel
    @Published private(set) var showQuantityLabel: Bool = false
    @Published var showDetail = false
    
    //FoodDetailView parameters
    @Published var detailFoodCount = 1
    
    init(food: Food, foodVM: FoodViewModel){
        self.foodVM = foodVM
        self.orderedFood = OrderedFood(id: UUID().uuidString, food: food, count: 0, price: 0, specialWishes: "")
    }
    
    //MARK: - Category helper methods
    func displayQuantityLabel(){
        withAnimation(.easeInOut(duration: 0.4)) {
            showQuantityLabel = true
            increaseQuantityButtonTapped()
        }
    }
    
    func increaseQuantityButtonTapped(){
        orderedFood.count += 1
        orderedFood.price += orderedFood.food.price
        setupOrderedFood()
    }
    
    func decreaseQuantityButtonTapped(){
        if orderedFood.count > 1{
            orderedFood.count -= 1
            orderedFood.price -= orderedFood.food.price
            setupOrderedFood()
        }else{
            withAnimation(.easeInOut(duration: 0.4)) {
                showQuantityLabel = false
                foodVM.orderedFoods.removeValue(forKey: orderedFood.id)
                orderedFood.count -= 1
                orderedFood.price -= orderedFood.food.price
            }
        }
    }
    
    private func setupOrderedFood(){
        if let food = foodVM.orderedFoods[orderedFood.id] {
            foodVM.orderedFoods[food.id] = orderedFood
        }else{
            foodVM.orderedFoods[self.orderedFood.id] = orderedFood
        }
    }
    
    //MARK: - FoodDetailView helper methods
    
    func increaseDetailViewCount(){
        detailFoodCount += 1
    }
    
    func decreaseDetailViewCount(){
        if detailFoodCount > 1{
            detailFoodCount -= 1
        }
    }
    
    func addChangesButtonTapped(){
        if !showQuantityLabel{
            withAnimation(.easeInOut(duration: 0.4)) {
                showQuantityLabel = true
            }
        }
        showDetail = false
        orderedFood.count += detailFoodCount
        orderedFood.price += (orderedFood.food.price * Double(detailFoodCount))
        setupOrderedFood()
    }
}
