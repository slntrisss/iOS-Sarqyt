//
//  TableInfo.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 16.04.2023.
//

import Foundation
import UIKit

struct TableInfo: Codable, Identifiable{
    let id: String
    let floor: Int
    let numberOfChairs: Int
    let reservePrice: Double
    let availableTimeInterval: [String]
    let description: String
    let images: [String]
    
    func wrappedImage(for base64String: String) -> UIImage{
        ImageService.convertBase64ToImage(base64: base64String)
    }
}
