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
                                address: Address(city: "Almaty", location: "9613 Bellevue St.Athens, GA 30605"),
                                details: RestaurantDetails(),
                                image: "restaurant1",
                                rating: 4.8,
                                reviewAmount: 4563,
                                reserveAmount: 15000,
                                bookmarked: false)
    
    let restaurants = [
        Restaurant(id: UUID().uuidString,
                   name: "Palazzo Hotel",
                   address: Address(city: "Almaty", location: "9613 Bellevue St.Athens, GA 30605"),
                   details: RestaurantDetails(),
                   image: "restaurant1",
                   rating: 4.8,
                   reviewAmount: 4563,
                   reserveAmount: 15000,
                   bookmarked: false),
        
        Restaurant(id: UUID().uuidString,
                   name: "Bulgari Hotel",
                   address: Address(city: "Almaty", location: "940 N. Delaware Road Uniondale, NY 11553"),
                   details: RestaurantDetails(),
                   image: "restaurant2",
                   rating: 3.7,
                   reviewAmount: 1563,
                   reserveAmount: 5000,
                   bookmarked: false),
        
        Restaurant(id: UUID().uuidString,
                   name: "Amsterdam, Netherlands",
                   address: Address(city: "Almaty", location: "4 West Alton Avenue Torrance, CA 90505"),
                   details: RestaurantDetails(),
                   image: "restaurant3",
                   rating: 4.7,
                   reviewAmount: 4563,
                   reserveAmount: 19000,
                   bookmarked: true),
        
        Restaurant(id: UUID().uuidString,
                   name: "Martinez Channes Hotel",
                   address: Address(city: "Almaty", location: "62 Shadow Brook Lane Fenton, MI 48430"),
                   details: RestaurantDetails(),
                   image: "restaurant4",
                   rating: 2.7,
                   reviewAmount: 563,
                   reserveAmount: 4000,
                   bookmarked: false),
        
        Restaurant(id: UUID().uuidString,
                   name: "Palms Casino Hotel",
                   address: Address(city: "Almaty", location: "9613 Bellevue St.Athens, GA 30605"),
                   details: RestaurantDetails(),
                   image: "restaurant5",
                   rating: 2.9,
                   reviewAmount: 563,
                   reserveAmount: 7000,
                   bookmarked: false),
        
        Restaurant(id: UUID().uuidString,
                   name: "London, UK",
                   address: Address(city: "Almaty", location: "20 Bridgeton St.Thibodaux, LA 70301"),
                   details: RestaurantDetails(),
                   image: "restaurant6",
                   rating: 4.1,
                   reviewAmount: 3563,
                   reserveAmount: 17000,
                   bookmarked: true),
        
        Restaurant(id: UUID().uuidString,
                   name: "Martinez Channes Hotel",
                   address: Address(city: "Almaty", location: "62 Shadow Brook Lane Fenton, MI 48430"),
                   details: RestaurantDetails(),
                   image: "restaurant7",
                   rating: 2.7,
                   reviewAmount: 563,
                   reserveAmount: 4000,
                   bookmarked: false),
    ]
}

extension PreviewProvider{
    
    static var dev: DeveloperPreview{
        return DeveloperPreview.instance
    }
}
