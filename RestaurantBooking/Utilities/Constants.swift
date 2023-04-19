//
//  Constants.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 17.04.2023.
//

import Foundation

class Constants{
    
    static let BASE_URL = "http://localhost:3000"
    
    //MARK: Home
    static let ALL_RESTAURANTS = "/Home/Restaurants"
    static let RECOMMENDATIONS_PREVIEW = "/Home/RecommendationPreview"
    static let PROMOTIONS_PREVIEW = "/Home/PromotionPreview"
    static let RECOMMENDED_RESTAURANTS = "/Home/RecommendedRestaurants"
    static let PROMOTED_RESTAURANTS = "/Home/PromotedRestaurants"
    static let BOOKMARK_RESTAURANT = "/Home/Restaurants/Bookmark"
    
    //MARK: Detail
    static let DETAILS = "/Detail"
    static let COMMENTS = "/Comments"
    
    //MARK: Food
    static let FOOD_BASE_URL = "/Food"
    static let FOOD_TYPES = "/Food/FoodTypes"
    static let FOOD_LIST = "/List"
    
    //MARK: Book
    static let BOOK_BASE_URL = "/Book"
    static let BOOKING_RESTAURANT = "/Book/BookingRestaurant"
    static let TABLE_INFO = "Book/TableInfo"
    
    //MARK: RestaurantScheme
    static let RESTAURANT_SCHEME = "/Scheme"
    
    //MARK: Pagination
    static let DEFAULT_OFFSET = 0
    static let DEFAULT_LIMIT = 5
}
