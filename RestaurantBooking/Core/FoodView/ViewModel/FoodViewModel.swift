//
//  FoodViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.03.2023.
//

import Foundation
import SwiftUI

class FoodViewModel: ObservableObject{
    @Published var foods: [Food] = []
    @Published var orderedFoods: [OrderedFood] = []
    @Published private var selectedTabIndex = 0
    var tabBars: [String] = []
    
    init(){
        tabBars.insert("All", at: 0)
        tabBars.append(contentsOf: FoodType.allCases.map({String($0.rawValue)}))
        foods = DeveloperPreview.instance.foods
    }
    
    func selectTabBar(at index: Int, scrollView: ScrollViewProxy){
        withAnimation {
            selectedTabIndex = index
            scrollView.scrollTo(index, anchor: .center)
        }
        if selectedTabIndex == 0{
            foods = DeveloperPreview.instance.foods
        }else{
            let type = tabBars[index + 1]
            foods = foods.filter({$0.type.rawValue == type})
        }
    }
    
    func getSelectedTabBarColor(at index: Int) -> Color{
        return selectedTabIndex == index ? Color.theme.green : Color.theme.secondaryButton
    }
    
    func getSelectedTabBarFont(at index: Int) -> Font{
        return selectedTabIndex == index ? Font.headline : Font.subheadline
    }
    
    var topSafeAreaInset: CGFloat? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topWindow = windowScene.windows.first {
            return topWindow.safeAreaInsets.top
        }
        return nil
    }
    
    func createOrderedFood(with food: Food) -> OrderedFood{
        return OrderedFood(id: UUID().uuidString, food: food, count: 1, price: food.price, specialWishes: "")
    }
}
