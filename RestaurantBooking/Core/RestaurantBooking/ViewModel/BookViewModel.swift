//
//  BookViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 12.03.2023.
//

import SwiftUI
import Combine

class BookViewModel: ObservableObject{
    @Published var continueButtonTapped = false
    @Published var showOrderFoodAlertView = false
    @Published var showRequiredFieldsMissedAlertView = false
    @Published var navigateToFoodView = false
    @Published var navigateToOrderView = false
    var cancellables = Set<AnyCancellable>()
    
    @Published var selectedDate = Date()
    @Published var numberOfGuests = -1
    @Published var selectedTime = ""
    @Published var specialWishes = ""
    var totalPriceForBooking = 0.0
    
    //Restaurant booking
    let bookingService = BookDataService.instance
    var bookedRestaurant: BookedRestaurant? = nil
    var restaurant: Restaurant? = nil
    var bookingRestaurant: BookingRestaurant? = nil
    
    //Food ordering
    @Published var orderedFoods: [String : OrderedFood] = [:]
    
    init(restaurant: Restaurant){
        self.restaurant = restaurant
    }
    
    func setupBookingRestaurant(){
        addSubscribers()
    }
    

    //MARK: - UI Components
    
    //MARK: RestaurantBookingView
    var allowedDatesToChoose:ClosedRange<Date>{
        guard let minDate = bookingRestaurant?.availableBookingTimeInterval.min(),
              let maxDate = bookingRestaurant?.availableBookingTimeInterval.max() else{return Date()...Date()}
        return minDate...maxDate
    }
    
    func navigateToOrderViewTapped(){
        navigateToOrderView = true
    }
    
    func navigateToFoodViewTapped(){
        navigateToFoodView = true
    }
    
    //MARK: - Order View Dependencies
    //TODO: Optimize BookedRestaurant for Views
    var wrappedBookedRestaurant: BookedRestaurant{
        if let bookedRestaurant = bookedRestaurant{
            return bookedRestaurant
        }
        return DeveloperPreview.instance.bookedRestaurant
    }
    
    var wrappedOrderedFoods: [OrderedFood]{
        return orderedFoods.map({$0.value})
    }
    
    //MARK: - FoodView dependecies
    var restaurantNameTitle: String{
        if let title = restaurant?.name{
            return title
        }
        return ""
    }
    
    //MARK: - Networking
    private func addSubscribers(){
        bookingService.fetchBookingRestaurant(for: restaurant?.id ?? "")
        bookingService.$bookingRestaurant
            .sink { [weak self] fetchedResult in
                self?.bookingRestaurant = fetchedResult
                
            }
            .store(in: &cancellables)
    }
}
