//
//  BookingViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 04.03.2023.
//

import Foundation

class BookingViewModel: ObservableObject{
    @Published var cancelledBookings: [Restaurant] = []
    @Published var completedBookings: [Restaurant] = []
    @Published var ongoingBookings: [Restaurant] = []
    
    init(){
        cancelledBookings = DeveloperPreview.instance.restaurants.filter({$0.bookingStatus == .cancelled})
        completedBookings = DeveloperPreview.instance.restaurants.filter({$0.bookingStatus == .completed})
        ongoingBookings = DeveloperPreview.instance.restaurants.filter({$0.bookingStatus == .ongoing})
    }
}
