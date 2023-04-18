//
//  Food.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.03.2023.
//

import Foundation
import UIKit

struct Food: Codable, Identifiable{
    let id: String
    let name: String
    let image: String
    let type: FoodType
    let price: Double
    let description: String
    
    var wrappedImage: UIImage{
        return ImageService.convertBase64ToImage(base64: image)
    }
}
