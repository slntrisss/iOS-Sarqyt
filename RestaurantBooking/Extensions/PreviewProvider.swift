//
//  PreviewProvider.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import SwiftUI

class DeveloperPreview{
    static let instance = DeveloperPreview()
    private init(){}
    let collections = Category.allCases.map{$0.rawValue}
    
    let restaurants = [
        Restaurant(id: UUID().uuidString, name: "Palazzo Hotel", address: "9613 Bellevue St.Athens, GA 30605"),
        Restaurant(id: UUID().uuidString, name: "Bulgari Hotel", address: "940 N. Delaware Road Uniondale, NY 11553"),
        Restaurant(id: UUID().uuidString, name: "Amsterdam, Netherlands", address: "4 West Alton Avenue Torrance, CA 90505"),
        Restaurant(id: UUID().uuidString, name: "Martinez Channes Hotel", address: "62 Shadow Brook Lane Fenton, MI 48430"),
        Restaurant(id: UUID().uuidString, name: "Palms Casino Hotel", address: "9613 Bellevue St.Athens, GA 30605"),
        Restaurant(id: UUID().uuidString, name: "London, UK", address: "20 Bridgeton St.Thibodaux, LA 70301"),
        Restaurant(id: UUID().uuidString, name: "Amsterdam, Netherlands", address: "4 West Alton Avenue Torrance, CA 90505")
    ]
}

extension PreviewProvider{
    
    static var dev: DeveloperPreview{
        return DeveloperPreview.instance
    }
}
