//
//  OrderViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 25.03.2023.
//

import Foundation
import SwiftUI
import Combine

class OrderViewModel: ObservableObject{
    @Published var showAllPaymentsMethodLists = false
    @Published var totalPrice = 0.0
    @Published var bookVM: BookViewModel{
        didSet{
            print("Changing")
        }
    }
    @Published var showFoodView = false
    @Published var showRestaurantBookingView = false
    @Published var confirmButtonTapped = false
    @Published var showCheckmark = -60.0
    var cancellables = Set<AnyCancellable>()
    let bookDataService = BookDataService.instance
    init(bookVM: BookViewModel){
        self.bookVM = bookVM
        addSubscribers()
    }
    
    var bookingTimeInterval: String{
        return "\(bookedDate)\n\(bookVM.selectedTime)"
    }
    
    private var bookedDate: String{
        return bookVM.selectedDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    func increaseGuestsAmount(){
        if let maxGuestAmount = bookVM.maxGuestsQuantity,
           bookVM.numberOfGuests < maxGuestAmount{
            bookVM.numberOfGuests += 1
        }
    }
    
    func decreaseGuestsAmount(){
        if bookVM.numberOfGuests > 1{
            bookVM.numberOfGuests -= 1
        }
    }
    
    func increaseFoodQuantity(for food: OrderedFood){
        bookVM.orderedFoods[food.id]?.count += 1
    }
    
    func decreaseFoodQuantity(for food: OrderedFood){
        if var foodToBeUpdated = bookVM.orderedFoods[food.id]{
            foodToBeUpdated.count -= 1
            if foodToBeUpdated.count <= 0{
                bookVM.orderedFoods[food.id] = nil
                return
            }
            bookVM.orderedFoods[food.id]?.count = foodToBeUpdated.count
        }
    }
    
    func changeOrderedFoodsButtonTapped(){
        bookVM.secondaryCheckView = true
        showFoodView = true
    }
    
    func changeRestaurantBookingButtonTapped(){
        bookVM.secondaryCheckView = true
        showRestaurantBookingView = true
    }
    
    private func addSubscribers(){
        bookVM.$reservePrice
            .combineLatest(bookVM.$foodPrice)
            .sink { [weak self] (reservePrice, foodPrice) in
                self?.totalPrice = reservePrice + foodPrice
            }
            .store(in: &cancellables)
    }
    
    func confirm(){
        confirmButtonTapped = true
        if let bookedRestaurant = bookVM.createBookedRestautant(){
            let orderedFoods = bookVM.wrappedOrderedFoods
            bookDataService.bookRestaurant(bookedRestaurant: bookedRestaurant, orderedFoods: orderedFoods)
        }
        
        bookDataService.$restaurantBooked
            .sink { [weak self] isBooked in
                if isBooked != nil{
                    DispatchQueue.main.async {
                        self?.showCheckmark = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        self?.confirmButtonTapped = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        NavigationUtil.popToRootView()
                    }
                }
            }
            .store(in: &cancellables)
    }
}
