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
    
    func floorNumberTapped(at index: Int){
//        withAnimation(.spring()){
            selectedFloor = index
//        }
    }
    
    
    //MARK: - For UI Components
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
}
