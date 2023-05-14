//
//  BookingViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 04.03.2023.
//

import Foundation
import Combine
import SwiftUI

class BookingViewModel: ObservableObject{
    @Published var cancelledBookings: [Restaurant] = []
    @Published var completedBookings: [Restaurant] = []
    @Published var ongoingBookings: [Restaurant] = []
    
    var bookingDetail: ReservedRestaurantDetail? = nil
    
    let ongoingPageInfo = PageInfo(itemsLoaded: 0)
    let completedPageInfo = PageInfo(itemsLoaded: 0)
    let cancelledPageInfo = PageInfo(itemsLoaded: 0)
    
    @Published var cancelBooking = false
    @Published var viewTicket = false
    
    @Published var showCheckmark = -60.0
    @Published var showPasscodeView = false
    @Published var showProgressView = false
    
    let dataService = ReservedRestaurantDataService.instance
    var cancellables = Set<AnyCancellable>()
    
    //MARK: Loading view
    @Published var ongoingRestaurantsPlacholder = DeveloperPreview.instance.ongoingRestaurants
    @Published var completedRestaurantsPlacholder = DeveloperPreview.instance.completedRestaurants
    @Published var cancelledRestaurantsPlacholder = DeveloperPreview.instance.cancelledRestaurants
    @Published var isOngoingRestaurantsLoading = true
    @Published var isCompletedRestaurantsLoading = true
    @Published var isCancelledRestaurantsLoading = true
    @Published var reservationDetailsLoading = true
    @Published var isOngoingListEmpty = false
    @Published var isCompletedListEmpty = false
    @Published var isCancelledListEmpty = false
    func viewTicketButtonTapped(restaurantId: String){
        
    }
    
    func addSubscriptions(){
        dataService.$ongoingRestaurants
            .sink { [weak self] fetchedRestaurants in
                if let fetchedRestaurants = fetchedRestaurants{
                    self?.isOngoingRestaurantsLoading = false
                    self?.ongoingBookings.append(contentsOf: fetchedRestaurants)
                    
                    if let ongoingBookings = self?.ongoingBookings,
                       (ongoingBookings.isEmpty || ongoingBookings.count == 0){
                        self?.isOngoingListEmpty = true
                    }
                }
            }
            .store(in: &cancellables)
        
        dataService.$completedRestaurants
            .sink { [weak self] fetchedRestaurants in
                if let fetchedRestaurants = fetchedRestaurants{
                    self?.isCompletedRestaurantsLoading = false
                    self?.completedBookings.append(contentsOf: fetchedRestaurants)
                    
                    if let completedBookings = self?.completedBookings,
                       (completedBookings.isEmpty || completedBookings.count == 0){
                        self?.isCompletedListEmpty = true
                    }
                }
            }
            .store(in: &cancellables)
        
        dataService.$cancelledRestaurants
            .sink { [weak self] fetchedRestaurants in
                if let fetchedRestaurants = fetchedRestaurants{
                    self?.isCancelledRestaurantsLoading = false
                    self?.cancelledBookings.append(contentsOf: fetchedRestaurants)
                    
                    if let cancelledBookings = self?.cancelledBookings,
                       (cancelledBookings.isEmpty || cancelledBookings.count == 0){
                        self?.isCancelledListEmpty = true
                    }
                }
            }
            .store(in: &cancellables)
        
        dataService.$reservationDetails
            .sink { [weak self] fetchedDetail in
                if let fetchedDetail = fetchedDetail{
                    self?.reservationDetailsLoading = false
                    self?.bookingDetail = fetchedDetail
                }
            }
            .store(in: &cancellables)
        
        dataService.$cancellBookingSuccess
            .sink { [weak self] success in
                if success{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.showCheckmark = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                        self?.showProgressView = false
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func showEmptyPlaceholder(status: BookingStatus) -> Bool {
        switch status{
        case .ongoing:
            return isOngoingListEmpty
        case .completed:
            return isCompletedListEmpty
        case .cancelled:
            return isCancelledListEmpty
        default:
            return false
        }
    }
}

//MARK: - Networking 
extension BookingViewModel{
    func fetchInitialData(for status: BookingStatus){
        print("Loading: \(status)")
        switch status{
        case .ongoing :
            print("\(ongoingBookings.count)")
            if (ongoingBookings.isEmpty || ongoingBookings.count == 0){
                dataService.fecthRestaurants(for: status, offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
            }
        case .completed:
            if (completedBookings.isEmpty || completedBookings.count == 0){
                dataService.fecthRestaurants(for: status, offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
            }
        default :
            if (cancelledBookings.isEmpty || cancelledBookings.count == 0){
                dataService.fecthRestaurants(for: status, offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
            }
        }

//        dataService.fecthRestaurants(for: status, offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
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
            pageInfo.offset += Constants.DEFAULT_LIMIT
            dataService.fecthRestaurants(for: status, offset: pageInfo.offset, limit: Constants.DEFAULT_LIMIT)
        }
    }
    
    func refreshItems(for status: BookingStatus){
        switch status{
        case .ongoing:
            isOngoingRestaurantsLoading = true
            isOngoingListEmpty = false
            refreshItems(for: status, restaurants: &ongoingBookings, pageInfo: ongoingPageInfo)
        case .completed:
            isCompletedRestaurantsLoading = true
            isCompletedListEmpty = false
            refreshItems(for: status, restaurants: &completedBookings, pageInfo: completedPageInfo)
        default:
            isCancelledRestaurantsLoading = true
            isCancelledListEmpty = false
            refreshItems(for: status, restaurants: &cancelledBookings, pageInfo: cancelledPageInfo)
        }
    }
    
    private func refreshItems(for status: BookingStatus, restaurants: inout [Restaurant], pageInfo: PageInfo){
        restaurants.removeAll()
        pageInfo.offset = 0
        dataService.fecthRestaurants(for: status, offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
    }
    
    func getReservedRestaurantDetail(for restaurantId: String){
        dataService.fetchReservedRestaurantDetail(for: restaurantId)
    }
    
    func cancelBooking(for restaurant: Restaurant){
        dataService.cancelBookingRestaurant(restaurant: restaurant)
    }
    
    func addPasscodeSubscription(passcodeVM: PasscodeViewModel, for restaurant: Restaurant){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [weak self] in
            withAnimation(.spring()){
                self?.showPasscodeView = true
            }
        }
        passcodeVM.$authSuccess
            .sink { [weak self] success in
                if success {
                    withAnimation(.spring()){
                        self?.showPasscodeView = false
                        self?.showProgressView = true
                    }
                    self?.cancelBooking(for: restaurant)
                }
            }
            .store(in: &cancellables)
    }
}

