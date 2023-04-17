//
//  NetworkingError.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 17.04.2023.
//

import Foundation

enum NetworkingError: LocalizedError{
    case badURLResponse(url: URL)
    case badURL(url: URL)
    case unkown
    
    var errorDescription: String?{
        switch self{
        case .badURLResponse(url: let url):
            return "Bad response from URL: \(url)"
        case .badURL(url: let url):
            return "Given URL does not seem to exist: \(url)"
        case .unkown:
            return "Unkown error occured."
        }
    }
}
