//
//  Date.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 25.03.2023.
//

import Foundation

extension Date{
    ///Returns start of the day
    var startOfDay: Date{
        Calendar.current.startOfDay(for: self)
    }
}
