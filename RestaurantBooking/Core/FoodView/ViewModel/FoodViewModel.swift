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
            foods = foods.filter({$0.type == FoodType.allCases.first(where: {$0 == foods[index].type})})
        }
    }
    
    func getSelectedTabBarColor(at index: Int) -> Color{
        return selectedTabIndex == index ? Color.theme.green : Color.theme.secondaryButton
    }
    
    func getSelectedTabBarFont(at index: Int) -> Font{
        return selectedTabIndex == index ? Font.headline : Font.subheadline
    }
}
