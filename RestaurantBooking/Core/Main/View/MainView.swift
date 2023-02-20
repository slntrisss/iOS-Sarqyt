//
//  MainView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import SwiftUI

struct MainView: View {
    init(){
        UIScrollView.appearance().keyboardDismissMode = .interactive
    }
    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            BookingView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                    Text("Booking")
                }
            MapView()
                .tabItem {
                    Image(systemName: "globe.asia.australia")
                    Text("Map")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Profile")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
