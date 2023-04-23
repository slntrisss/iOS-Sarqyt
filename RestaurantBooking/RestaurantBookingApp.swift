//
//  RestaurantBookingApp.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

@main
struct RestaurantBookingApp: App {
    @StateObject private var navVM = NavigationViewModel()
    var body: some Scene {
        WindowGroup {
            ZStack{
                Color.theme.background
                    .ignoresSafeArea()
                MainView()
            }
        }
    }
}
