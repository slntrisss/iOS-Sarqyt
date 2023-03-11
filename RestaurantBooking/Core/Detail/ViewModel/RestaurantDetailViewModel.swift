//
//  RestaurantDetailViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 08.03.2023.
//

import MapKit
import SwiftUI

class RestaurantDetailViewModel: ObservableObject{
    @Published var restaurant: Restaurant
    @Published var comments: [Comment]
    @Published var mapRegion: MKCoordinateRegion
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    @Published var mainImageOffset: CGFloat = 0
    
    let detailComments: [Comment]
    
    init(){
        let restaurant = DeveloperPreview.instance.restaurant
        self._restaurant = Published(initialValue: restaurant)
        let coordinates = restaurant.address.coordinates
        mapRegion = MKCoordinateRegion(center: coordinates, span: mapSpan)
        
        let comments = DeveloperPreview.instance.comments
        self.comments = comments
        
        if comments.count > 3 {
            detailComments = Array(comments.prefix(3))
        }else{
            detailComments = comments
        }
    }
    
    var topSafeAreaInset: CGFloat? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topWindow = windowScene.windows.first {
            return topWindow.safeAreaInsets.top
        }
        return nil
    }
    
    var reviews: String{
        if restaurant.reviewAmount > 0{
            let count = Double(restaurant.reviewAmount)
            return "(\(count.formattedWithAbbreviations()) \(count > 1 ? "reviews" : "review"))"
        }
        return ""
    }
    
    func getSize() -> CGFloat{
        if mainImageOffset > 200{
            let progress = (mainImageOffset - 200) / 50
            return progress <= 1.0 ? (progress * 40) : 40
        }
        return 0
    }
    
    func getStatus(for rating: Int) -> Double{
        switch rating{
        case 5:return restaurant.details.commentRatingStatus[0]
        case 4:return restaurant.details.commentRatingStatus[1]
        case 3:return restaurant.details.commentRatingStatus[2]
        case 2:return restaurant.details.commentRatingStatus[3]
        case 1:return restaurant.details.commentRatingStatus[4]
        default:return 0
        }
    }
}
