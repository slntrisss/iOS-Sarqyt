//
//  RestaurantListViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 17.04.2023.
//

import Foundation
import Combine

class RestaurantListViewModel: ObservableObject{
    @Published var restaurants: [Restaurant] = []
    let restaurantDataService = RestaurantDataService.instance
    let pageInfo = PageInfo(itemsLoaded: 0)
    var cancellables = Set<AnyCancellable>()
    let listType: RestaurantListType
    init(listType: RestaurantListType){
        self.listType = listType
        addSubscribers()
    }
    
    func refreshList(){
        restaurants.removeAll()
        pageInfo.offset = 0
        switch listType{
        case .recommended: restaurantDataService.getRecommendedRestaurants(offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
        case .promoted : restaurantDataService.getPromotedRestaurants(offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
        case .bookmarked : print("...")
        }
        restaurantDataService.getRecommendedRestaurants(offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
    }
    
    func requestMoreItems(index: Int){
        if index == restaurants.count - 1{
            print("More items in \(listType)...")
            pageInfo.offset += Constants.DEFAULT_LIMIT
            switch listType{
            case .recommended: restaurantDataService.getRecommendedRestaurants(offset: pageInfo.offset, limit: Constants.DEFAULT_LIMIT)
            case .promoted : restaurantDataService.getPromotedRestaurants(offset: pageInfo.offset, limit: Constants.DEFAULT_LIMIT)
            case .bookmarked : print("...")
            }
        }
    }
    
    enum RestaurantListType{
        case recommended
        case promoted
        case bookmarked
    }
}

extension RestaurantListViewModel{
    
    private func addSubscribers(){
        switch listType{
        case .bookmarked: print("...")
        case .promoted: addPromotedRestaurantsSubscription()
        case .recommended: addRecommendedRestaurantsSubscription()
        }
    }
    
    private func addRecommendedRestaurantsSubscription(){
        restaurantDataService.getRecommendedRestaurants(offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
        restaurantDataService.$recommendedRestaurants
            .sink { [weak self] fetchedRestaurants in
                self?.restaurants.append(contentsOf: fetchedRestaurants)
                self?.pageInfo.itemsLoaded = self?.restaurants.count ?? 0
            }
            .store(in: &cancellables)
    }
    
    private func addPromotedRestaurantsSubscription(){
        restaurantDataService.getPromotedRestaurants(offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
        restaurantDataService.$promotedRestaurants
            .sink { [weak self] fetchedRestaurants in
                self?.restaurants.append(contentsOf: fetchedRestaurants)
                self?.pageInfo.itemsLoaded = self?.restaurants.count ?? 0
            }
            .store(in: &cancellables)
    }
}
