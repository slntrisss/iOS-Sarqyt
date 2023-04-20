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
    var cancellables = Set<AnyCancellable>()
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
}
