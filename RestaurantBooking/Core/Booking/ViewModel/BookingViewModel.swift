//
//  BookingViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 04.03.2023.
//

import Foundation
import Combine

class BookingViewModel: ObservableObject{
    @Published var cancelledBookings: [Restaurant] = []
    @Published var completedBookings: [Restaurant] = []
    @Published var ongoingBookings: [Restaurant] = []
    
    let ongoingPageInfo = PageInfo(itemsLoaded: 0)
    let completedPageInfo = PageInfo(itemsLoaded: 0)
    let cancelledPageInfo = PageInfo(itemsLoaded: 0)
    
    @Published var cancelBooking = false
    @Published var viewTicket = false
    
    let dataService = ReservedRestaurantDataService.instance
    var cancellables = Set<AnyCancellable>()
    init(){
        addSubscriptions()
    }
    
    func viewTicketButtonTapped(restaurantId: String){
        
    }
    
    private func addSubscriptions(){
        dataService.$ongoingRestaurants
            .sink { [weak self] fetchedRestaurants in
                self?.ongoingBookings.append(contentsOf: fetchedRestaurants)
            }
            .store(in: &cancellables)
        
        dataService.$completedRestaurants
            .sink { [weak self] fetchedRestaurants in
                self?.completedBookings.append(contentsOf: fetchedRestaurants)
            }
            .store(in: &cancellables)
        
        dataService.$cancelledRestaurants
            .sink { [weak self] fetchedRestaurants in
                self?.cancelledBookings.append(contentsOf: fetchedRestaurants)
            }
            .store(in: &cancellables)
    }
}

//MARK: - Networking 
extension BookingViewModel{
    func fetchInitialData(for status: BookingStatus){
        print("Loading: \(status)")
        dataService.fecthRestaurants(for: status, offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
    }
    
    func requestMoreItems(for status: BookingStatus, index: Int){
        switch status{
        case .ongoing: requestMoreItems(for: status, index: index, restaurants: ongoingBookings, pageInfo: ongoingPageInfo)
        case .completed: requestMoreItems(for: status, index: index, restaurants: completedBookings, pageInfo: completedPageInfo)
        default: requestMoreItems(for: status, index: index, restaurants: cancelledBookings, pageInfo: cancelledPageInfo)
        }
    }
    
    private func requestMoreItems(for status: BookingStatus, index: Int, restaurants: [Restaurant], pageInfo: PageInfo){
        if restaurants.count - 1 == index {
            pageInfo.offset += Constants.DEFAULT_OFFSET
            dataService.fecthRestaurants(for: status, offset: pageInfo.offset, limit: Constants.DEFAULT_LIMIT)
        }
    }
    
    func refreshItems(for status: BookingStatus){
        switch status{
        case .ongoing: refreshItems(for: status, restaurants: &ongoingBookings, pageInfo: ongoingPageInfo)
        case .completed: refreshItems(for: status, restaurants: &completedBookings, pageInfo: completedPageInfo)
        default: refreshItems(for: status, restaurants: &cancelledBookings, pageInfo: cancelledPageInfo)
        }
    }
    
    private func refreshItems(for status: BookingStatus, restaurants: inout [Restaurant], pageInfo: PageInfo){
        restaurants.removeAll()
        pageInfo.offset = 0
        dataService.fecthRestaurants(for: status, offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
    }
}

