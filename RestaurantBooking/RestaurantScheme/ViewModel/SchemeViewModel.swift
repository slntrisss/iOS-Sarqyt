//
//  SchemeViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 08.04.2023.
//

import SwiftUI

class SchemeViewModel: ObservableObject{
    let scheme: RestaurantScheme
    @Published var selectedFloor = 0
    @Published var mapItemGroupSelectOptions: [Bool]
    var selectedIndex = -1
    init(){
        scheme = DeveloperPreview.instance.scheme
        mapItemGroupSelectOptions = Array(repeating: false, count: scheme.floors[0].groups.count)
    }
    
    func groupItemTapped(at index: Int){
        withAnimation {
            if(scheme.floors[selectedFloor].groups[index].reserved){
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
}
