//
//  HomeViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    @Published var searchQuery = ""
    @Published var restaurants: [Restaurant] = DeveloperPreview.instance.restaurants
    @Published var recentSearchHistory: [Restaurant] = []
    
    @Published var showRecommended = false
    @Published var showPromoted = false
    @Published var showBookmarked = false
    
    @Published var bookmarkedRestaurants: [Restaurant] = []
    
    var cancellables = Set<AnyCancellable>()
    init(){
        recentSearchHistory = DeveloperPreview.instance.restaurants
        subscribe()
    }
    
    func deleteSearchHistory(at offsets: IndexSet){
        recentSearchHistory.remove(atOffsets: offsets)
    }
    
    func getRecommnededRestaurants(){
        
    }
    
    func getPromotedRestaurants(){
        
    }
    
    func getBookmarkedRestaurants(){
        bookmarkedRestaurants = restaurants.filter{$0.bookmarked}
    }
    
    func removeFromBookmarked(restaurant: Restaurant){
        if let index = bookmarkedRestaurants.firstIndex(where: {$0.id == restaurant.id}){
            bookmarkedRestaurants.remove(at: index)
        }
        if let index = restaurants.firstIndex(where: {$0.id == restaurant.id}){
            restaurants[index].bookmarked.toggle()
        }
    }
    
    func bookmarkRestaurant(restaurant: Restaurant){
        if let index = bookmarkedRestaurants.firstIndex(where: {$0.id == restaurant.id}){
            restaurants[index].bookmarked.toggle()
        }
    }
    
    func subscribe(){
        $restaurants
            .sink {[weak self] restaurants in
                guard let self = self else{return}
                let bookmarked = self.restaurants.filter({$0.bookmarked})
                for i in bookmarked{
                    print(i.name)
                }
                print("\n")
            }
            .store(in: &cancellables)
    }
}
