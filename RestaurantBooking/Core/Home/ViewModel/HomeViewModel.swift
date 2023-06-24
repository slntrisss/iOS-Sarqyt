//
//  HomeViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject{
    @Published var filterVM = FilterViewModel()
    
    @Published var searchQuery = ""
    
    @Published var allRestaurants: [Restaurant] = []
    @Published var promotedRestaurants: [Restaurant] = []
    @Published var recommendedRestaurants: [Restaurant] = []
    @Published var searchedRestaurants: [Restaurant] = []
    
    @Published var recentSearchHistory: [Restaurant] = []
    
    @Published var searchingRestaurants = false
    @Published var searchedRestaurantsAreEmpty = false
    @Published var filterenabled = false
    @Published var searching = false
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
    
    //MARK: For Loading view
    @Published var placeHolderArray = DeveloperPreview.instance.restaurants
    @Published var isRecommendedRestaurantsLoading = true
    @Published var isPromotedRestaurantsLoading = true
    @Published var isRestaurantListLoading = true
    @Published var isRequestingMoreListOfRestaurants = false
    
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
    
    //MARK: - Networking
    func addSubscribers(){
        restaurantDataService.getAllRestaurants()
        
        restaurantDataService.$recommendedRestaurantsPreviewList
            .sink { [weak self] restaurants in
                if let restaurants = restaurants{
                    withAnimation {
                        self?.isRecommendedRestaurantsLoading = false
                    }
                    self?.recommendedRestaurants = restaurants
                }
            }
            .store(in: &cancellables)
        
        restaurantDataService.$promotedRestaurantsPreviewList
            .sink { [weak self] restaurants in
                if let restaurants = restaurants{
                    withAnimation {
                        self?.isPromotedRestaurantsLoading = false
                    }
                    self?.promotedRestaurants = restaurants
                }
            }
            .store(in: &cancellables)
        
        
        restaurantDataService.$restaurantList
            .sink { [weak self] restaurants in
                if let restaurants = restaurants{
                    withAnimation {
                        self?.isRestaurantListLoading = false
                    }
                    self?.allRestaurants.append(contentsOf: restaurants)
                    self?.pageInfo.itemsLoaded = self?.allRestaurants.count ?? 0
                }
                self?.isRequestingMoreListOfRestaurants = false
            }
            .store(in: &cancellables)
        
        $searchQuery
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink {[weak self] searchQuery in
                if searchQuery.count > 0{
                    self?.searchingRestaurants = true
                    self?.searching = true
                    self?.restaurantDataService.searchRestaurants(name: searchQuery, limit: 100, offset: 0)
                } else{
                    self?.searchingRestaurants = false
                }
            }
            .store(in: &cancellables)
        
        restaurantDataService.$searchedRestaurants
            .sink { [weak self] fetchedResults in
                if let restaurants = fetchedResults{
                    self?.searchedRestaurants = restaurants
                    self?.searching = false
                }
                if self?.searchQuery.count ?? 0 > 0 && ((fetchedResults?.isEmpty) != nil){
                    self?.searchedRestaurantsAreEmpty = false
                } else {
                    self?.searchedRestaurantsAreEmpty = true
                }
            }
            .store(in: &cancellables)
        
        filterVM.$filtering
            .sink {[weak self] filtering in
                if filtering{
                    self?.filterenabled = true
                    self?.allRestaurants.shuffle()
                }
            }
            .store(in: &cancellables)
    }
    
    func refreshHomeViewData(){
        filterenabled = false
        filterVM.filteringRestaurants = false
        isRestaurantListLoading = true
        isRecommendedRestaurantsLoading = true
        isPromotedRestaurantsLoading = true
        allRestaurants.removeAll()
        recommendedRestaurants.removeAll()
        promotedRestaurants.removeAll()
        pageInfo.offset = 0
        restaurantDataService.getAllRestaurants()
    }
    
    func requestMoreItems(index: Int) {
        if index == allRestaurants.count - 1{
            print("More items in home_view...")
            isRequestingMoreListOfRestaurants = true
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
