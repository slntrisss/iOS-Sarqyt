//
//  NavigationViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 22.04.2023.
//

import Foundation
import SwiftUI

class NavigationViewModel: ObservableObject{
    @Published var path: NavigationPath = NavigationPath()
}
