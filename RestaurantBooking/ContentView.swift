//
//  ContentView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false
    let authService = AuthService.shared
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
            if authService.authenticated() || isAuthenticated{
                MainView()
            }else{
                SignInView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
