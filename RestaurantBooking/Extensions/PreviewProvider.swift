//
//  PreviewProvider.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import SwiftUI

class DeveloperPreview{
    static let instance = DeveloperPreview()
    
    let collections = Category.allCases.map{$0.rawValue}
    
    private init(){}
    
    let restaurant = Restaurant(id: UUID().uuidString,
                                name: "Palazzo Hotel",
                                address: Address(city: "Almaty",
                                                 location: "9613 Bellevue St.Athens, GA 30605",
                                                 latitude: 41.8902,
                                                 longitude: 12.4922),
                                details: RestaurantDetails(),
                                image: "restaurant1",
                                rating: 4.8,
                                reviewAmount: 4563,
                                reserveAmount: 15000,
                                bookmarked: false,
                                bookingStatus: .cancelled)
    
    let restaurants = [
        Restaurant(id: UUID().uuidString,
                   name: "Palazzo Hotel",
                   address: Address(city: "Almaty",
                                    location: "9613 Bellevue St.Athens, GA 30605",
                                    latitude: 41.8986,
                                    longitude: 12.4769),
                   details: RestaurantDetails(),
                   image: "restaurant1",
                   rating: 4.8,
                   reviewAmount: 4563,
                   reserveAmount: 15000,
                   bookmarked: false,
                   bookingStatus: .ongoing),
        
        Restaurant(id: UUID().uuidString,
                   name: "Bulgari Hotel",
                   address: Address(city: "Almaty",
                                    location: "940 N. Delaware Road Uniondale, NY 11553",
                                    latitude: 41.9009,
                                    longitude: 12.4833),
                   details: RestaurantDetails(),
                   image: "restaurant2",
                   rating: 3.7,
                   reviewAmount: 1563,
                   reserveAmount: 5000,
                   bookmarked: false,
                   bookingStatus: .cancelled),
        
        Restaurant(id: UUID().uuidString,
                   name: "Amsterdam, Netherlands",
                   address: Address(city: "Almaty",
                                    location: "4 West Alton Avenue Torrance, CA 90505",
                                    latitude: 48.8584,
                                    longitude: 2.2945),
                   details: RestaurantDetails(),
                   image: "restaurant3",
                   rating: 4.7,
                   reviewAmount: 4563,
                   reserveAmount: 19000,
                   bookmarked: true,
                   bookingStatus: .completed),
        
        Restaurant(id: UUID().uuidString,
                   name: "Martinez Channes Hotel",
                   address: Address(city: "Almaty",
                                    location: "62 Shadow Brook Lane Fenton, MI 48430",
                                    latitude: 48.8606,
                                    longitude: 2.3376),
                   details: RestaurantDetails(),
                   image: "restaurant4",
                   rating: 2.7,
                   reviewAmount: 563,
                   reserveAmount: 4000,
                   bookmarked: false,
                   bookingStatus: .completed),
        
        Restaurant(id: UUID().uuidString,
                   name: "Palms Casino Hotel",
                   address: Address(city: "Almaty",
                                    location: "9613 Bellevue St.Athens, GA 30605",
                                    latitude: 44.8606,
                                    longitude: 5.3376),
                   details: RestaurantDetails(),
                   image: "restaurant5",
                   rating: 2.9,
                   reviewAmount: 563,
                   reserveAmount: 7000,
                   bookmarked: false,
                   bookingStatus: .cancelled),
        
        Restaurant(id: UUID().uuidString,
                   name: "London, UK",
                   address: Address(city: "Almaty",
                                    location: "20 Bridgeton St.Thibodaux, LA 70301",
                                    latitude: 44.8606,
                                    longitude: 1.3376),
                   details: RestaurantDetails(),
                   image: "restaurant6",
                   rating: 4.1,
                   reviewAmount: 3563,
                   reserveAmount: 17000,
                   bookmarked: true,
                   bookingStatus: .ongoing),
        
        Restaurant(id: UUID().uuidString,
                   name: "Martinez Channes Hotel",
                   address: Address(city: "Almaty",
                                    location: "62 Shadow Brook Lane Fenton, MI 48430",
                                    latitude: 24.8606,
                                    longitude: 1.9376),
                   details: RestaurantDetails(),
                   image: "restaurant7",
                   rating: 2.7,
                   reviewAmount: 563,
                   reserveAmount: 4000,
                   bookmarked: false,
                   bookingStatus: .cancelled),
    ]
    
    let filterData = FilterProvider.shared
}

extension DeveloperPreview{
    class FilterProvider{
        static let shared = FilterProvider()
        private init(){}
        
        let availableCities = ["Almaty", "Astana", "Semey", "Takdykorgan", "Oskemen", "Aktau", "Shymkent"]
        let categories = Category.allCases.map{$0.rawValue}
        let availableRatings = [5, 4, 3, 2, 1]
        let availableFacilities = ["Wi-Fi", "Parking", "Terassa", "Blues"]
        let accomodationTypes = ["Pizzerias", "Cafés", "Fast casual restaurants", "Casual dining restaurants"]
    }
}

extension PreviewProvider{
    
    static var dev: DeveloperPreview{
        return DeveloperPreview.instance
    }
}
