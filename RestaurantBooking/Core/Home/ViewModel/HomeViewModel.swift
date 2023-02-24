//
//  HomeViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    @Published var filterVM = FilterViewModel()
    
    @Published var searchQuery = ""
    @Published var allRestaurants: [Restaurant] = DeveloperPreview.instance.restaurants
    @Published var recentSearchHistory: [Restaurant] = []
    
    @Published var showRecommended = false
    @Published var showPromoted = false
    @Published var showBookmarked = false
    
    @Published var restaurants: [Restaurant] = []
    
    var cancellables = Set<AnyCancellable>()
    
    init(){
        recentSearchHistory = DeveloperPreview.instance.restaurants
    }
    
    func deleteSearchHistory(at offsets: IndexSet){
        recentSearchHistory.remove(atOffsets: offsets)
    }
    
    func getRecommnededRestaurants(){
        restaurants = allRestaurants.filter({$0.rating > 3})
    }
    
    func getPromotedRestaurants(){
        restaurants = allRestaurants.filter({$0.rating > 4})
    }
    
    func getBookmarkedRestaurants(){
        restaurants = allRestaurants.filter{$0.bookmarked}
    }
    
    func removeFromBookmarked(restaurant: Restaurant){
        if let index = restaurants.firstIndex(where: {$0.id == restaurant.id}){
            restaurants.remove(at: index)
        }
        if let index = allRestaurants.firstIndex(where: {$0.id == restaurant.id}){
            allRestaurants[index].bookmarked.toggle()
        }
    }
    
    func bookmarkRestaurant(restaurant: Restaurant){
        if let index = restaurants.firstIndex(where: {$0.id == restaurant.id}){
            allRestaurants[index].bookmarked.toggle()
        }
    }
}
