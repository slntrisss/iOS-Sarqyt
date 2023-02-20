//
//  HomeViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import Foundation

class HomeViewModel: ObservableObject{
    @Published var searchQuery = ""
    @Published var restaurants: [Restaurant] = DeveloperPreview.instance.restaurants
    @Published var recentSearchHistory: [Restaurant] = []
    @Published var categories: [String] = []
    @Published var selectedCategory = Category.recommended.rawValue
    init(){
        categories = Category.allCases.map{$0.rawValue}
        recentSearchHistory = DeveloperPreview.instance.restaurants
    }
    
    func deleteSearchHistory(at offsets: IndexSet){
        recentSearchHistory.remove(atOffsets: offsets)
    }
}
