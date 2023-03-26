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
    var totalPriceForBooking = 0.0
    private(set) var selectedTimeIntervalIndex = -1
    
    var dateArray: [Date] = []
    
    let bookingService = BookingService.shared
    
    //Restaurant booking
    var restaurant: Restaurant? = nil
    var bookingRestaurant: BookingRestaurant? = nil
    
    //Food ordering
    @Published var orderedFoods: [String : OrderedFood] = [:]
    
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
        
        if selectedTimeIntervalIndex == -1{
            showRequiredFieldsMissedAlertView = true
            return
        }
        
        if orderedFoods.isEmpty{
            showOrderFoodAlertView = true
            return
        }
    }
}
