//
//  BookViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 12.03.2023.
//

import SwiftUI

class BookViewModel: ObservableObject{
    @Published var book = Book()
    let futureDateRange = Date.now...
    var dateArray: [Date] = []
    @Published var selectedTimeInterval: Date? = nil
    init(){
        let calendar = Calendar.current
        let startDate = Date() // the starting date (now)
        let endDate = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: startDate)!) // the end date (midnight of the next day)
        let interval = TimeInterval(30 * 60) // 30 minutes in seconds
        
        

        var currentDate = startDate

        while currentDate <= endDate {
            dateArray.append(currentDate)
            currentDate = calendar.date(byAdding: .second, value: Int(interval), to: currentDate)!
        }

        // If the last date added to the array is after midnight, remove it
        if let lastDate = dateArray.last, calendar.isDate(lastDate, inSameDayAs: endDate) == false {
            dateArray.removeLast()
        }
        
    }
    
    func isSelectedTimeInterval(index: Int) -> Bool{
        return selectedTimeInterval == dateArray[index]
    }
    
    func increaseNumberOfGuests(){
        if book.numberOfGuests < 10{
            book.numberOfGuests += 1
        }
    }
    
    func decreaseNumberOfGuests(){
        if book.numberOfGuests > 1{
            book.numberOfGuests -= 1
        }
    }
    
    private func constructNumberOfGuestsLabel() -> String{
        if book.numberOfGuests > 1{
            return "\(book.numberOfGuests) Guests"
        }
        return "\(book.numberOfGuests) Guest"
    }
    
    func getGuestsLabel() -> String{
        return constructNumberOfGuestsLabel()
    }
}
