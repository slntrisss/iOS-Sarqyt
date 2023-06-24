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
    
    @Published var filteringRestaurants = false
    @Published var filtering = false
    @Published var filteredRestaurantsAreEmpty = false
    
    @Published var filteredRestaurants:[Restaurant] = []
    
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
    
    func reset(){
        selectedCity = ""
        selectedCategory = ""
        selectedPrice = ""
        selectedRating = 0
        selectedFacilities = []
        selectedAccomodationTypes = []
        
        fromPriceAmount = 0
        tillPriceAmount = 0
    }
    
    func fetchFilteredRestaurants(){
        var facilities:[String] = []
        var accomodationTypes:[String] = []
        for i in selectedFacilities.indices{
            if selectedFacilities[i]{
                facilities.append(filterData?.facilities[i] ?? "")
            }
        }
        
        for i in selectedAccomodationTypes.indices{
            if selectedAccomodationTypes[i]{
                accomodationTypes.append(filterData?.accomodationTypes[i] ?? "")
            }
        }
        
        let filter = RestaurantFilter(city: self.selectedCity,
                                      category: self.selectedCategory,
                                      fromPrice: Double(fromPriceAmount),
                                      toPrice: Double(tillPriceAmount),
                                      rating: Double(self.selectedRating),
                                      facilities: facilities,
                                      accomodationTypes: accomodationTypes)
        self.filteringRestaurants = true
        self.filtering = true
        dataService.fetchRestaurants(by: filter)
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
        
        dataService.$restaurants
            .sink { [weak self] restaurants in
                if let restaurants = restaurants{
                    self?.filteredRestaurants = restaurants
                    self?.filtering = false
                    self?.filteredRestaurantsAreEmpty = restaurants.count <= 0
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
