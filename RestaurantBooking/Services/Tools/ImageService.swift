//
//  ImageService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 17.04.2023.
//

import UIKit

class ImageService{
    static func convertBase64ToImage(base64: String) -> UIImage{
        if let base64String = base64.data(using: .utf8){
            if let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters){
                if let image = UIImage(data: imageData){
                    return image
                }
            }
        }
        print("BAD Base64")
        return UIImage(systemName: "photo.fill")!
    }
}
