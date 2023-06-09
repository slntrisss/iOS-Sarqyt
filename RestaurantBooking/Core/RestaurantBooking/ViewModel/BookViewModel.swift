//
//  BookViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 12.03.2023.
//

import SwiftUI
import Combine

class BookViewModel: ObservableObject{
    @Published var continueButtonTapped = false{
        didSet{
            checkForValidity()
        }
    }
    @Published var secondaryCheckView = false
    @Published var showOrderFoodAlertView = false
    @Published var showRequiredFieldsMissedAlertView = false
    @Published var navigateToFoodView = false
    @Published var navigateToOrderView = false
    var cancellables = Set<AnyCancellable>()
    
    @Published var selectedDate = Date()
    @Published var numberOfGuests = 1
    @Published var selectedTime = ""
    @Published var specialWishes = ""
    @Published var selectedTableId: String? = nil
    @Published var maxGuestsQuantity: Int? = nil
    
    //Restaurant booking
    let bookingService = BookDataService.instance
    @Published var bookedRestaurant: BookedRestaurant? = nil
    var restaurant: Restaurant? = nil
    var bookingRestaurant: BookingRestaurant? = nil
    
    //Food ordering
    @Published var orderedFoods: [String : OrderedFood] = [:]
    
    //Price
    @Published var foodPrice = 0.0
    @Published var reservePrice = 0.0
    
    //Loading view
    @Published var isLoading = true
    
    init(restaurant: Restaurant){
        self.restaurant = restaurant
    }
    
    func setupBookingRestaurant(schemeVM: SchemeViewModel){
        addSubscribers(schemeVM: schemeVM)
    }
    

    //MARK: - UI Components
    
    //MARK: RestaurantBookingView
    var allowedDatesToChoose:ClosedRange<Date>{
        guard let minDate = bookingRestaurant?.availableBookingTimeInterval.min(),
              let maxDate = bookingRestaurant?.availableBookingTimeInterval.max() else{
            print("Cannot init date range for datepicker")
            return Date()...Date().addingTimeInterval(60 * 60)
        }
        print(minDate)
        print(maxDate)
        return minDate...maxDate
    }
    
    func navigateToOrderViewTapped(){
        navigateToOrderView = true
    }
    
    func navigateToFoodViewTapped(){
        navigateToFoodView = true
    }
    
    private func checkForValidity(){
        if selectedTime.isEmpty{
            showRequiredFieldsMissedAlertView = true
            return
        }
        if secondaryCheckView{
            return
        }
        if orderedFoods.values.isEmpty{
            showOrderFoodAlertView = true
            return
        }
        navigateToOrderView = true
    }
    
    func createBookedRestautant() -> BookedRestaurant?{
        if let restaurant = restaurant, let tableId = selectedTableId{
            self.bookedRestaurant = BookedRestaurant(id: UUID().uuidString, restaurantId: restaurant.id, numberOfGuests: numberOfGuests, selectedDate: selectedDate, selectedTime: selectedTime, specialWishes: specialWishes, selectedTableId: tableId)
        }
        return bookedRestaurant
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
    
    
    //MARK: - Networking
    private func addSubscribers(schemeVM: SchemeViewModel){
        bookingService.fetchBookingRestaurant(for: restaurant?.id ?? "")
        schemeVM.$tableInfo
            .sink { [weak self] fetchedInfo in
                self?.maxGuestsQuantity = fetchedInfo?.numberOfChairs
                self?.reservePrice = fetchedInfo?.reservePrice ?? 0.0
            }
            .store(in: &cancellables)
        schemeVM.$selectedGroupItem
            .sink { [weak self] selectedGroupItem in
                if let id = selectedGroupItem?.id{
                    self?.selectedTableId = id
                }
            }
            .store(in: &cancellables)
        bookingService.$bookingRestaurant
            .sink { [weak self] fetchedResult in
                if let fetchedResult = fetchedResult{
                    self?.isLoading = false
                    self?.bookingRestaurant = fetchedResult
                }
            }
            .store(in: &cancellables)
        $orderedFoods
            .sink { [weak self] publishedOrderedFoods in
                self?.foodPrice = 0
                for food in publishedOrderedFoods.values{
                    self?.foodPrice += (food.price * Double(food.count))
                }
            }
            .store(in: &cancellables)
    }
}
