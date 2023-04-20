//
//  FoodCardViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 22.03.2023.
//

import SwiftUI

class FoodCardViewModel: ObservableObject{
    @Published var orderedFood: OrderedFood
    @Published var bookVM: BookViewModel
    @Published private(set) var showQuantityLabel: Bool = false
    @Published var showDetail = false
    @Published var specialWishes = ""
    let food: Food
    
    //FoodDetailView parameters
    @Published var detailFoodCount = 1
    
    init(food: Food, bookVM: BookViewModel){
        self.bookVM = bookVM
        self.food = food
        if bookVM.orderedFoods[food.id] != nil{
            showQuantityLabel = true
        }
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
        if bookVM.orderedFoods[food.id] != nil{
            bookVM.orderedFoods[food.id]?.count += 1
            bookVM.orderedFoods[food.id]?.price += food.price
        }else{
            bookVM.orderedFoods[food.id] = OrderedFood(id: food.id, food: food, count: 1, price: food.price, specialWishes: "")
        }
    }
    
    func decreaseQuantityButtonTapped(){
        if var orderedFood = bookVM.orderedFoods[food.id]{
            if orderedFood.count > 1{
                orderedFood.count -= 1
                orderedFood.price -= food.price
                bookVM.orderedFoods[food.id] = orderedFood
            }else{
                withAnimation(.easeInOut(duration: 0.4)){
                    showQuantityLabel = false
                    bookVM.orderedFoods.removeValue(forKey: food.id)
                    orderedFood.count -= 1
                    orderedFood.price -= food.price
                    orderedFood.specialWishes = ""
                }
            }
        }
    }
    
    var foodPriceLabel: Double{
        if let orderedFood = bookVM.orderedFoods[food.id] {
            return orderedFood.price
        }
        return food.price
    }
    
    var foodQuantity: Int{
        if let orderedFood = bookVM.orderedFoods[food.id] {
            return orderedFood.count
        }
        return 0
    }
    
    func hideQuantityLabel(){
        if bookVM.orderedFoods[food.id] == nil{
            showQuantityLabel = false
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
        if var orderedFood = bookVM.orderedFoods[food.id]{
            orderedFood.count += detailFoodCount
            orderedFood.price += (orderedFood.food.price * Double(detailFoodCount))
            bookVM.orderedFoods[food.id] = orderedFood
        }else{
            let price = food.price * Double(detailFoodCount)
            bookVM.orderedFoods[food.id] = OrderedFood(id: food.id, food: food, count: detailFoodCount, price: price, specialWishes: specialWishes)
        }
    }
}
