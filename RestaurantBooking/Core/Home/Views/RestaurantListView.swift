//
//  RestaurantListView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 24.02.2023.
//

import SwiftUI

struct RestaurantListView: View {
    @EnvironmentObject private var homeVM: HomeViewModel
    let title: String
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            ForEach(homeVM.restaurants.indices, id: \.self) { index in
                RestaurantCardView(restaurant: $homeVM.restaurants[index])
                    .environmentObject(homeVM)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .transition(.move(edge: .leading))
            }
            .animation(.easeOut, value: homeVM.restaurants)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RestaurantListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            RestaurantListView(title: "My Bookmarked")
                .environmentObject(HomeViewModel())
        }
    }
}
