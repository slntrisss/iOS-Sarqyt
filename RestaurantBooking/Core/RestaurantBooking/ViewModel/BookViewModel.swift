//
//  BookViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 12.03.2023.
//

import SwiftUI

class BookViewModel: ObservableObject{
    @Published var selectedDate = Date(){
        didSet{
            self.setupAvailableTimeIntervals()
            self.computeTotalBookingPrice()
        }
    }
    @Published var selectedTimeInterval: Date? = nil{didSet{computeTotalBookingPrice()}}
    @Published var continueButtonTapped = false
    @Published var numberOfGuests = 1
    @Published var specialWishes = ""
    @Published var showOrderFoodAlertView = false
    @Published var showRequiredFieldsMissedAlertView = false
    @Published var navigateToFoodView = false
    @Published var navigateToOrderView = false
    var totalPriceForBooking = 0.0
    private(set) var selectedTimeIntervalIndex = -1
    
    var dateArray: [Date] = []
    
    let bookingService = BookingService.shared
    
    //Restaurant booking
    var restaurant: Restaurant? = nil
    var bookingRestaurant: BookingRestaurant? = nil
    
    //Food ordering
    @Published var orderedFoods: [String : OrderedFood] = [:]
    
    var bookedRestaurant: BookedRestaurant? = nil
    
    init(restaurant: Restaurant){
        self.restaurant = restaurant
    }
    
    func setupBookingRestaurant(){
        self.bookingRestaurant = bookingService.getBookingRestaurant()
        setupAvailableTimeIntervals()
        computeTotalBookingPrice()
    }
    
    func setupRestaurant(restaurant: Restaurant){
        self.restaurant = restaurant
    }
    
    func setSelectedTimeInterval(index: Int){
        self.selectedTimeIntervalIndex = index
        self.selectedTimeInterval = dateArray[index]
    }
    
    private func computeTotalBookingPrice(){
        guard let bookingRestaurant = bookingRestaurant else{return}
        totalPriceForBooking = 0
        if numberOfGuests > 0{
            totalPriceForBooking += (Double(numberOfGuests) * bookingRestaurant.pricePerGuest)
        }
        
        if selectedTimeIntervalIndex != -1,
           let prices = bookingRestaurant.prices[selectedDate.startOfDay]{
            totalPriceForBooking += prices[selectedTimeIntervalIndex]
        }
    }

    //MARK: - UI Components
    
    //MARK: RestaurantBookingView
    var allowedDatesToChoose:ClosedRange<Date>{
        guard let minDate = bookingRestaurant?.availableBookingTimeInterval.keys.min(),
              let maxDate = bookingRestaurant?.availableBookingTimeInterval.keys.max() else{return Date()...Date()}
        return minDate...maxDate
    }
    
    func isSelectedTimeInterval(index: Int) -> Bool{
        return selectedTimeInterval == dateArray[index]
    }
    
    func increaseNumberOfGuests(){
        if let maxNumberOfGuest = bookingRestaurant?.maxGuestNumber, numberOfGuests < maxNumberOfGuest{
            numberOfGuests += 1
            computeTotalBookingPrice()
        }
    }
    
    func decreaseNumberOfGuests(){
        if numberOfGuests > 1{
            numberOfGuests -= 1
            computeTotalBookingPrice()
        }
    }
    
    private func constructNumberOfGuestsLabel() -> String{
        if numberOfGuests > 1{
            return "\(numberOfGuests) Guests"
        }
        return "\(numberOfGuests) Guest"
    }
    
    func getGuestsLabel() -> String{
        return constructNumberOfGuestsLabel()
    }
    
    private func setupAvailableTimeIntervals(){
        if let dateArray = bookingRestaurant?.availableBookingTimeInterval[selectedDate.startOfDay]{
            self.dateArray = dateArray
        }
        selectedTimeIntervalIndex = -1
    }
    
    func bookButtonTapped(){
        if(!isBookedRestaurantValid()){
            showRequiredFieldsMissedAlertView = true
        }else if orderedFoods.isEmpty{
            showOrderFoodAlertView = true
        }else{
            navigateToOrderView = true
            createRestaurantBooking()
        }
    }
    
    func navigateToOrderViewTapped(){
        createRestaurantBooking()
        navigateToOrderView = true
    }
    
    func navigateToFoodViewTapped(){
        createRestaurantBooking()
        navigateToFoodView = true
    }
    
    private func createRestaurantBooking(){
        guard let restaurant = restaurant,
              let selectedTimeInterval = selectedTimeInterval else{
            print("Restaurant and/or selectedTimeInterval are not valid or nil.")
            return
        }
        
        bookedRestaurant = BookedRestaurant(id: UUID().uuidString, restaurant: restaurant, numberOfGuests: numberOfGuests, selectedDate: selectedDate, selectedTime: selectedTimeInterval, specialWishes: specialWishes)
    }
    
    private func isBookedRestaurantValid() -> Bool{
        if(selectedTimeInterval == nil && selectedTimeIntervalIndex == -1){
            return false
        }
        return true
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
}
