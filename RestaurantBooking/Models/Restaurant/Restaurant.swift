//
//  Restaurant.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//
import Foundation
import MapKit
import SwiftUI

struct Restaurant: Codable, Identifiable, Equatable, Hashable{
    let id: String
    let name: String
    let address: Address
    let image: String
    let rating: Double
    let reviewAmount: Int
    let reserveAmount: Double
    var bookmarked: Bool
    var bookingStatus: BookingStatus
    
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.id == rhs.id
    }
    
    var wrappedImage: UIImage{
        return ImageService.convertBase64ToImage(base64: image)
    }
}

struct Address: Codable, Hashable{
    let city: String
    let location: String
    let latitude: Double
    let longitude: Double
    
    var coordinates: CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}

struct RestaurantDetails: Codable, Hashable, Identifiable{
    let id: String
    let description: String
    static let categories:[String] = ["Italian's kitchen", "China's kitchen", "Children room", "pizza", "Vegetarian"]
    let phoneNumber: String
    let instragramLink: String?
    let metaLink: String?
    let commentRatingStatus: [Double]
}
