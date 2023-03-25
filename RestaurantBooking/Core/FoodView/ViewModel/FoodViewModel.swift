//
//  FoodViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.03.2023.
//


import SwiftUI

class FoodViewModel: ObservableObject{
    @Published var foods: [Food] = []
    @Published private var selectedTabIndex = 0
    @Published private var bookVM: BookViewModel
    @Published var showOrderButton = false
    @Published private(set) var orderButtonTapped = false
    @Published var showRestaurantBookingAlertView = false
    var tabBars: [String] = []
    
    init(bookVM: BookViewModel){
        tabBars.insert("All", at: 0)
        tabBars.append(contentsOf: FoodType.allCases.map({String($0.rawValue)}))
        foods = DeveloperPreview.instance.foods
        self.bookVM = bookVM
    }
    
    
    //MARK: - UI components
    
    //MARK: TabBar logic
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
    
    func displayOrderButton(){
        if !bookVM.orderedFoods.isEmpty{
            self.showOrderButton = true
        }else{
            self.showOrderButton = false
        }
    }
    
    var orderButtonLabelText: String{
        var count = 0
        var totalPrice = 0.0
        for (_, orderedFood) in bookVM.orderedFoods{
            count += orderedFood.count
            totalPrice += orderedFood.price
        }
        return "Order \(count) for ₸\(totalPrice.toKZTCurrency())"
    }
    
    //MARK: - Restaurant Booking Alert View
    func navigateToOrderView(){
        if bookVM.bookingRestaurant == nil{
            showRestaurantBookingAlertView = true
            return
        }
    }
    
    func openRestaurantBookingViewButtonTapped(){
        showRestaurantBookingAlertView = false
    }
    
    func cancelOrderButtonTapped(){
        showRestaurantBookingAlertView = false
    }
}
