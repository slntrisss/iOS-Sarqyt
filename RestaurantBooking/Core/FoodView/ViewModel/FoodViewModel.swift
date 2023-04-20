//
//  FoodViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.03.2023.
//


import SwiftUI
import Combine

class FoodViewModel: ObservableObject{
    @Published var foods: [Food] = []
    @Published private var selectedTabIndex = 0
    @Published private var bookVM: BookViewModel
    @Published var showOrderButton = false
    @Published private(set) var orderButtonTapped = false
    @Published var showRestaurantBookingAlertView = false
    @Published var showOrderView = false
    @Published var navigateToRestaurantBookingView = false
    var tabBars: [FoodType] = []
    
    let foodDataService = FoodDataService.instance
    
    let pageInfo = PageInfo(itemsLoaded: 0)
    
    var cancellables = Set<AnyCancellable>()
    
    init(bookVM: BookViewModel){
        self.bookVM = bookVM
        print("Started downloading...")
        addSubscribers()
        fetchInitialData()
    }
    
    
    //MARK: - UI components
    
    //MARK: TabBar logic
    func selectTabBar(at index: Int, scrollView: ScrollViewProxy){
        if let restaurant = bookVM.restaurant{
            withAnimation {
                selectedTabIndex = index
                scrollView.scrollTo(index, anchor: .center)
            }
            
            let foodType = tabBars[selectedTabIndex]
            fetchFoods(for: restaurant, of: foodType)
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
        if bookVM.selectedTime.isEmpty{
            navigateToRestaurantBookingView = true
            return
        }
        showOrderView = true
    }
    
    func openRestaurantBookingViewButtonTapped(){
        showRestaurantBookingAlertView = false
        navigateToRestaurantBookingView = true
    }
    
    func cancelOrderButtonTapped(){
        showRestaurantBookingAlertView = false
    }
    
    //MARK: - Networking
    private func fetchInitialData(){
        if let restaurant = bookVM.restaurant{
            foodDataService.fetchFoodTitles(for: restaurant.id)
        }
    }
    
    private func addSubscribers(){
        foodDataService.$types
            .sink { [weak self] fetchedTypes in
                self?.tabBars = fetchedTypes
                if ((self?.foods.isEmpty) != nil){
                    self?.foodDataService.fetchFoods(for: self?.bookVM.restaurant?.id ?? "",
                                               of: fetchedTypes.first?.id ?? "",
                                               offset: Constants.DEFAULT_OFFSET,
                                               limit: Constants.DEFAULT_LIMIT)
                }
            }
            .store(in: &cancellables)
        
        foodDataService.$foods
            .sink { [weak self] fetchedFoods in
                self?.foods.append(contentsOf: fetchedFoods)
            }
            .store(in: &cancellables)
    }
    
    func requestMoreFoods(index: Int){
        if let restaurant = bookVM.restaurant,
           index == foods.count - 1{
            print("More foods...")
            pageInfo.offset += Constants.DEFAULT_LIMIT
            foodDataService.fetchFoods(for: restaurant.id,
                                       of: tabBars[selectedTabIndex].id,
                                       offset: pageInfo.offset,
                                       limit: Constants.DEFAULT_LIMIT)
        }
    }
    
    func refreshFoods(){
        if let restaurant = bookVM.restaurant{
            foods.removeAll()
            pageInfo.offset = 0
            foodDataService.fetchFoods(for: restaurant.id,
                                       of: tabBars[selectedTabIndex].id,
                                       offset: Constants.DEFAULT_OFFSET,
                                       limit: Constants.DEFAULT_LIMIT)
        }
    }
    
    private func fetchFoods(for restaurant: Restaurant, of foodType: FoodType){
        foods.removeAll()
        pageInfo.offset = 0
        foodDataService.fetchFoods(for: restaurant.id,
                                   of: foodType.id,
                                   offset: Constants.DEFAULT_OFFSET,
                                   limit: Constants.DEFAULT_LIMIT)
    }
}
