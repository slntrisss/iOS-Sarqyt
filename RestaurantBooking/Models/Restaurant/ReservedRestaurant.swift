//
//  ReservedRestaurant.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.06.2023.
//

import Foundation
import UIKit
import SwiftUI

struct ReservedRestaurant: Codable, Identifiable, Equatable, Hashable{
    let id: String
    let name: String
    let address: Address
    let image: String
    let rating: Double
    let reviewAmount: Int
    let reserveAmount: Double
    var bookmarked: Bool
    var bookingStatus: BookingStatus
    let orderItemId: String
    
    static func == (lhs: ReservedRestaurant, rhs: ReservedRestaurant) -> Bool {
        return lhs.id == rhs.id
    }
    
    var wrappedImage: UIImage{
        return ImageService.convertBase64ToImage(base64: image)
    }
}
