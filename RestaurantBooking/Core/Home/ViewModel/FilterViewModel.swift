//
//  FilterViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 24.02.2023.
//

import Foundation
import Combine

class FilterViewModel: ObservableObject{
    @Published var selectedCity = ""
    @Published var selectedCategory = ""
    @Published var selectedPrice = ""
    @Published var selectedRating: Int = 0
    @Published var selectedFacilities: [Bool] = []
    @Published var selectedAccomodationTypes: [Bool] = []
    
    @Published var fromPriceAmount: Int = 0
    @Published var tillPriceAmount: Int = 0
    
    var minPriceAmount: Int = 0
    var maxPriceAmount: Int = 0
    
    @Published var filterData: FilterData? = nil
    var cancellables = Set<AnyCancellable>()
    let dataService = FilterDataService.instance
    
    //MARK: Loadin view
    @Published var isLoading = true
    
    init(){
        addSubscriptions()
    }
    
    func validateRange(){
        if fromPriceAmount < minPriceAmount{
            fromPriceAmount = minPriceAmount
        }else if fromPriceAmount > tillPriceAmount{
            fromPriceAmount = minPriceAmount
            tillPriceAmount = maxPriceAmount
        }else if tillPriceAmount > maxPriceAmount{
            tillPriceAmount = maxPriceAmount
        }
    }
    
    //MARK: Networking
    func getFilterData(){
        dataService.getFilterData()
    }
    
    private func addSubscriptions(){
        dataService.$filterData
            .sink { [weak self] fetchedFilterData in
                if let fetchedFilterData = fetchedFilterData{
                    self?.isLoading = false
                    self?.filterData = fetchedFilterData
                    
                    self?.initData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func initData(){
        guard let filterData = filterData else{ return }
        let facilitiesCount = filterData.facilities.count
        selectedFacilities = Array<Bool>(repeating: false, count: facilitiesCount)
        
        let accomodationTypeCount = filterData.accomodationTypes.count
        selectedAccomodationTypes = Array<Bool>(repeating: false, count: accomodationTypeCount)
        
        minPriceAmount = Int(filterData.minPrice)
        maxPriceAmount = Int(filterData.maxPrice)
        
        fromPriceAmount = minPriceAmount
        tillPriceAmount = maxPriceAmount
    }
}
