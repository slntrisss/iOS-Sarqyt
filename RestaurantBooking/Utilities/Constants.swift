//
//  Constants.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 17.04.2023.
//

import Foundation

class Constants{
    
    //MARK: - Auth & Security
    static let USER_CEREDENTIALS = "user-credentials"
    static let SARQYT_ACCOUNT = "Sarqyt"
    static let ACCESS_TOKEN = "jwt-token"
    static let PASSCODE = "passcode"
    static let SIGN_IN = "/api/auth/login-mobile"
    static let SIGN_UP = "/api/auth/sign-up"
    static let SIGN_OUT = "/signout"
    
    //MARK: - Network Calls
    static let BASE_URL = "http://localhost:8000"
    
    //MARK: Home
    static let ALL_RESTAURANTS = "/api/restaurant/home/restaurant-list"
    static let RECOMMENDATIONS_PREVIEW = "/api/restaurant/home/recommendation-preview"
    static let PROMOTIONS_PREVIEW = "/api/restaurant/home/promotion-preview"
    static let RECOMMENDED_RESTAURANTS = "/api/restaurant/home/recommended-restaurants"
    static let PROMOTED_RESTAURANTS = "/api/restaurant/home/promoted-restaurants"
    static let BOOKMARK_RESTAURANT = "/Home/Restaurants/Bookmark"
    static let SEARCH_RESTAURANTS = "/api/restaurant/search-restaurants"
    
    static let FILTERED_RESTAURANTS = "/api/restaurant/filter-restaurants"
    static let FILTER_DATA = "/api/restaurant/load-filter-data"
    
    //MARK: Detail
    static let DETAILS = "/api/restaurant/details"
    static let COMMENTS = "/comments"
    static let RATE_RESTAURANT = "/rate-restaurant"
    
    //MARK: Food
    static let FOOD_BASE_URL = "/api/restaurant/food"
    static let FOOD_TYPES = "/api/restaurant/food/food-categories"
    static let FOOD_LIST = "/list"
    
    //MARK: Book
    static let BOOK_BASE_URL = "/api/restaurant/book"
    static let BOOKING_RESTAURANT = "/api/restaurant/booking/booking-restaurant-info"
    static let TABLE_INFO = "/api/restaurant/book/table-info"
    
    //MARK: RestaurantScheme
    static let RESTAURANT_SCHEME = "/api/restaurant/get-schemes"
    
    //MARK: ReservedRestaurants
    static let RESERVED_RESTAURANTS_BASE_URL = "/api/restaurant/load-orders-by-status"
    static let RESERVED_RESTAURANTS_DETAIL = "/api/restaurant/load-order-details"
    static let CANCEL_RESERVED_RESTAURANT = "/api/restaurant/cancel-booking"
    
    //MARK: Map
    static let MAP_BASE_URL = "/api/restaurant/load-map-data"
    
    //MARK: Profile
    static let PROFILE_BASE_URL = "/api/auth/create-profile"
    static let PROFILE = "/api/auth/load-profile"
    static let PAYMENT_CARDS = "/api/restaurant/profile/payment-cards"
    
    //MARK: Pagination
    static let DEFAULT_OFFSET = 0
    static let DEFAULT_LIMIT = 10
}
