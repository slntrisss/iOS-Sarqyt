//
//  OrderViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 25.03.2023.
//

import Foundation
import SwiftUI

class OrderViewModel: ObservableObject{
    @Published var showAllPaymentsMethodLists = false
    
    @Published var bookVM: BookViewModel{
        didSet{
            print("Changing")
        }
    }
    init(bookVM: BookViewModel){
        self.bookVM = bookVM
    }
    
    var bookingTimeInterval: String{
        return "\(bookedDate)\n\(bookedTime)"
    }
    
    private var bookedDate: String{
        return bookVM.wrappedBookedRestaurant.selectedDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    private var bookedTime: String{
        return bookVM.wrappedBookedRestaurant.selectedTime
    }
    
    func increaseGuestsAmount(){
        if let maxGuestAmount = bookVM.maxGuestsQuantity,
           let selectedGuestAmount = bookVM.bookedRestaurant?.numberOfGuests,
           selectedGuestAmount < maxGuestAmount{
            bookVM.bookedRestaurant?.numberOfGuests += 1
        }
    }
    
    func decreaseGuestsAmount(){
        if let bookedRestaurant = bookVM.bookedRestaurant, bookedRestaurant.numberOfGuests > 1{
            bookVM.bookedRestaurant?.numberOfGuests -= 1
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
}
