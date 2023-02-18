//
//  String.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import Foundation

extension String{
    
    ///Formats given phone number with length of 10 or 11 to human readable form
    ///```
    ///"77473456778" -> "+7-(747)-345-67-78"
    ///"7475507878" -> "+7-(747)-550-7878"
    ///```
    public mutating func formatPhoneNumber() {
        let digits = self.digitsOnly
        
        if digits.count == 11 {
            self = digits.replacingOccurrences(of: "(\\d{1})(\\d{3})(\\d{3})(\\d{4})", with: "+$1-($2)-$3-$4", options: .regularExpression, range: nil)
        }
    }
}

extension StringProtocol {

    ///Replaces all non-digit character with empty string
    ///```
    ///"(747)-345-dd/01/2001" -> "747345012001"
    ///"qwerty12345" -> "12345"
    ///"eve" -> ""
    ///```
    var digitsOnly: String {
        return String(filter(("0"..."9").contains))
    }

}
