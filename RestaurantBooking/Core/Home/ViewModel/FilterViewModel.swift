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
    @Published var selectedFacilities: [Bool]
    @Published var selectedAccomodationTypes: [Bool]
    
    @Published var fromPriceAmount: Int
    @Published var tillPriceAmount: Int
    
    let minPriceAmount: Int
    let maxPriceAmount: Int
    
    var cancellables = Set<AnyCancellable>()
    
    init(){
        let facilitiesCount = DeveloperPreview.FilterProvider.shared.availableFacilities.count
        selectedFacilities = Array<Bool>(repeating: false, count: facilitiesCount)
        
        let accomodationTypeCount = DeveloperPreview.FilterProvider.shared.accomodationTypes.count
        selectedAccomodationTypes = Array<Bool>(repeating: false, count: accomodationTypeCount)
        
        minPriceAmount = 2_300
        maxPriceAmount = 145_700
        
        fromPriceAmount = minPriceAmount
        tillPriceAmount = maxPriceAmount
        
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
}
