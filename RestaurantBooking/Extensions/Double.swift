//
//  Double.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import Foundation

extension Double{
    
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 123456 to 123.45K
    /// Convert 12345678 to 12.34M
    /// Convert 1234567890 to 1.23Bn
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
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
    func asNumberStringWithOneDigit() -> String{
        return String(format: "%.1f", self)
    }
    
    ///Converst a double into a String
    ///```
    /// Convert 1.23456 to "1.23"
    ///```
    func asNumberStringWithTwoDigits() -> String{
        return String(format: "%.2f", self)
    }
}
