//
//  SchemeViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 08.04.2023.
//

import SwiftUI
import Combine

class SchemeViewModel: ObservableObject{
    @Published var scheme: RestaurantScheme? = nil
    @Published var selectedFloor = 0
    @Published var mapItemGroupSelectOptions: [Bool] = []
    @Published var showTableInfoSheet = false
    var restaurantId = ""
    var selectedIndex = -1
    
    //Services
    let schemeDataService = SchemeDataService.instance
    let bookDataService = BookDataService.instance
    
    @Published var tableInfo: TableInfo? = nil
    
    @Published var dateArray: [String] = []
    @Published var selectedTimeIntervalIndex = -1
    @Published var numberOfGuests = -1
    @Published var selectedTime: String = ""
    @Published var saveChanges = false
    
    var cancellables = Set<AnyCancellable>()
    
    init(restaurantId: String){
        self.restaurantId = restaurantId
    }
    
    func groupItemTapped(at index: Int){
        withAnimation {
            if let scheme = scheme,
               scheme.floors[selectedFloor].groups[index].reserved {
                return
            }
            if selectedIndex >= 0{
                mapItemGroupSelectOptions[selectedIndex] = false
                mapItemGroupSelectOptions[index] = true
                selectedIndex = index
            }else{
                selectedIndex = index
                mapItemGroupSelectOptions[index] = true
            }
        }
    }
    
    func getTablePhotos(with restaurantId: String, selectedDate: Date, groupId: String, index: Int){
        showTableInfoSheet = true
        groupItemTapped(at: index)
        getTableInfo(for: restaurantId, date: selectedDate, groupId: groupId)
    }
    
    func floorNumberTapped(at index: Int){
        selectedFloor = index
    }
    
    
    //MARK: - For UI Components
    //MARK: Floor buttons
    func floorNumberFor(index: Int) -> String{
        var floorNumber = ""
        switch index {
        case 0: floorNumber = "1st "
        case 1: floorNumber = "2nd "
        case 3: floorNumber = "3rd "
        default: floorNumber = "\(index + 1)th "
        }
        floorNumber += "floor"
        return floorNumber
    }
    
    func forgroundColorForButton(at index: Int) -> Color{
        if selectedFloor == index{
            return Color.white
        }
        return Color.theme.accent.opacity(0.8)
    }
    
    func backgroundColorForButton(at index: Int) -> Color{
        if selectedFloor == index{
            return Color.theme.green.opacity(0.7)
        }
        return Color.theme.secondaryText.opacity(0.15)
    }
    
    //MARK: TimePicker
    
    func setSelectedTimeInterval(index: Int){
        if let tableInfo = tableInfo{
            selectedTimeIntervalIndex = index
            selectedTime = tableInfo.availableTimeInterval[selectedTimeIntervalIndex]
        }
    }
    
    func isSelectedTimeInterval(index: Int) -> Bool{
        return index == selectedTimeIntervalIndex
    }
    
    //MARK: Guest View
    var numberOfGuestsLabel: String{
        return numberOfGuests == 1 ? "\(numberOfGuests) Guest" : "\(numberOfGuests) Guests"
    }
    
    func increaseNumberOfGuests(){
        if let tableInfo = tableInfo,
           tableInfo.numberOfChairs > numberOfGuests{
            numberOfGuests += 1
        }
    }
    
    func decreaseNumberOfGuests(){
        if numberOfGuests > 1{
            numberOfGuests -= 1
        }
    }
    
    //MARK: - Networking
    //MARK: Scheme
    func setupRestaurantScheme(){
        schemeDataService.fetchRestaurantScheme(for: restaurantId)
        schemeDataService.$scheme
            .sink { [weak self] fetchedScheme in
                self?.scheme = fetchedScheme
                self?.mapItemGroupSelectOptions = Array(repeating: false, count: fetchedScheme?.floors[self?.selectedFloor ?? 0].groups.count ?? 0)
            }
            .store(in: &cancellables)
        
        bookDataService.$tableInfo
            .sink { [weak self] fetchedTableInfo in
                self?.tableInfo = fetchedTableInfo
            }
            .store(in: &cancellables)
    }
    
    //MARK: Table info
    private func getTableInfo(for restaurantId: String, date: Date, groupId: String){
        bookDataService.fetchTableInfo(for: restaurantId, date: date, groupId: groupId)
    }
}
