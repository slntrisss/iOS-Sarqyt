//
//  Color.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import Foundation
import SwiftUI

extension Color{
    static let theme = ThemeColor()
}

struct ThemeColor{
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let primaryButton = Color("PrimaryButtonColor")
    let secondaryButton = Color("SecondaryButtonColor")
    let secondaryText = Color("SecondaryTextColor")
    let field = Color("FieldColor")
    let sheetBackground = Color("SheetBackgroundColor")
    let collectionBackground = Color("CollectionBackgroundColor")
    let secondaryButtonText = Color("SecondaryButtonTextColor")
    let redStatus = Color("RedStatusColor")
    let greenStatus = Color("GreenStatusColor")
}
