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
    
    @Published var showRecommended = false
    @Published var showPromoted = false
    @Published var showBookmarked = false
    
    init(){
        recentSearchHistory = DeveloperPreview.instance.restaurants
    }
    
    func deleteSearchHistory(at offsets: IndexSet){
        recentSearchHistory.remove(atOffsets: offsets)
    }
    
    func getRecommnededRestaurants(){
        
    }
    
    func getPromotedRestaurants(){
        
    }
    
    func getBookmarkedRestaurants(){
        let recommendedRestaurants = restaurants.filter{$0.bookmarked}
        restaurants = recommendedRestaurants
    }
}
