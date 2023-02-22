//
//  Int.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 22.02.2023.
//

import Foundation

extension Int{
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberStringWithTwoDigits()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberStringWithTwoDigits()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberStringWithTwoDigits()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberStringWithTwoDigits()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberStringWithTwoDigits()

        default:
            return "\(sign)\(self)"
        }
    }
    
    ///Converts double into String
    ///```
    ///Convert 1.23456 to "1.2"
    ///```
    func asNumberStringWithTwoDigits() -> String{
        return String(format: "%.2f", self)
    }
}
