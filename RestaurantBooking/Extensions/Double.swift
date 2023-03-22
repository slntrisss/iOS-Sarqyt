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
    
    ///Converst a double into a percentage out of "5.0"
    ///```
    /// Convert 4.8 to "96%"
    ///```
    func toPercent() -> String{
        return "\(Int((self * 100) / 5.0))%"
    }
    
    
    //MARK: - Currency formatter
    ///Converts double amount of price into currency in KZT
    ///```
    ///Convert "1234.56" to "₸1 234,56"
    ///```
    func toKZTCurrency() -> String{
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "kk_KZ")
        formatter.numberStyle = .currency
        formatter.currencyCode = "KZT"
        
        if let formattedPrice = formatter.string(from: NSNumber(value: self)) {
            return formattedPrice // returns: "₸1 234,56"
        }
        return self.formattedWithAbbreviations()
    }
}
