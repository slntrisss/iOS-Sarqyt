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
    
    @Published var allRestaurants: [Restaurant] = []
    @Published var promotedRestaurants: [Restaurant] = []
    @Published var recommendedRestaurants: [Restaurant] = []
    
    @Published var recentSearchHistory: [Restaurant] = []
    
    @Published var showRecommended = false
    @Published var showPromoted = false
    @Published var showBookmarked = false
    
    @Published var restaurants: [Restaurant] = []
    
    let restaurantDataService = RestaurantDataService.instance
    
    @Published var showRestaurantDetailView = false
    var selectedRestaurant: Restaurant? = nil
    
    let pageInfo = PageInfo(itemsLoaded: 0)
    @Published var isLoading = true
    var cancellables = Set<AnyCancellable>()
    
    init(){
        recentSearchHistory = DeveloperPreview.instance.restaurants
        addSubscribers()
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
    
    //MARK: - Networking
    private func addSubscribers(){
        restaurantDataService.getAllRestaurants()
        
        restaurantDataService.$recommendedRestaurantsPreviewList
            .sink { [weak self] restaurants in
                self?.recommendedRestaurants = restaurants
            }
            .store(in: &cancellables)
        
        restaurantDataService.$promotedRestaurantsPreviewList
            .sink { [weak self] restaurants in
                self?.promotedRestaurants = restaurants
            }
            .store(in: &cancellables)
        
        
        restaurantDataService.$restaurantList
            .sink { [weak self] restaurants in
                self?.allRestaurants.append(contentsOf: restaurants)
                self?.pageInfo.itemsLoaded = self?.allRestaurants.count ?? 0
            }
            .store(in: &cancellables)
    }
    
    func refreshHomeViewData(){
        allRestaurants.removeAll()
        recommendedRestaurants.removeAll()
        promotedRestaurants.removeAll()
        pageInfo.offset = 0
        restaurantDataService.getAllRestaurants()
    }
    
    func requestMoreItems(index: Int) {
        if index == allRestaurants.count - 1{
            print("More items in home_view...")
            pageInfo.offset += Constants.DEFAULT_LIMIT
            restaurantDataService.getRestaurantList(
                offset: pageInfo.offset,
                limit: pageInfo.itemsFromEndTreshold
            )
        }
    }
    
    func bookmarkkRestaurant(restaurant: Restaurant){
        if let restaurant = restaurantDataService.bookmarkRestaurant(id: restaurant.id, bookmarked: restaurant.bookmarked){
            if let index = restaurants.firstIndex(where: {$0.id == restaurant.id}){
                allRestaurants[index].bookmarked.toggle()
            }
        }
    }
}
