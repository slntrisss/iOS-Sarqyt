//
//  HomeView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 19.02.2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeVM = HomeViewModel()
    @State private var searchFieldInFocus = false
    @State private var currentIndex = 0
    @State private var showPopupView = false
    var body: some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false) {
                SearchFieldView(searchQuery: $homeVM.searchQuery, searchFieldInFocus: $searchFieldInFocus)
                    .padding()
                ZStack{
                    if searchFieldInFocus && !homeVM.recentSearchHistory.isEmpty{
                        seacrhResultView
                    }else{
                        VStack{
                            recommendedRestaurantsView
                            promotedRestaurantsView
                            listOfRestaurants
                        }
                    }
                }
            }
            .navigationTitle("Hello, Raim 👋")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {navLeadingItems}
                ToolbarItem(placement: .navigationBarTrailing) {navTrailingItems}
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


extension HomeView{
    
    private var navLeadingItems: some View{
        HStack{
            Image("logo")
                .resizable()
                .scaledToFit()
            Text("Sarqyt")
                .font(.title.bold())
        }
    }
    
    private var navTrailingItems: some View{
        HStack{
            Button{
                //do something
            }label: {
                Image(systemName: "bell")
            }
            
            Button{
                //do something
                showPopupView.toggle()
            }label: {
                Image(systemName: "bookmark")
            }
        }
    }
    
    private var seacrhResultView: some View{
        VStack(alignment: .leading){
            HStack{
                Text("Recent")
                    .foregroundColor(Color.theme.accent)
                    .font(.caption.bold())
                Spacer()
            }
            List{
                ForEach(homeVM.recentSearchHistory) { restaurant in
                    HStack{
                        VStack(alignment: .leading, spacing: 5){
                            Text(restaurant.name)
                                .foregroundColor(Color.theme.accent.opacity(0.95))
                            Text(restaurant.address.location)
                                .font(.caption2)
                                .foregroundColor(Color.theme.secondaryText)
                        }
                        .padding(.vertical)
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.theme.secondaryText)
                    }
                }
                .onDelete(perform: homeVM.deleteSearchHistory)
            }
            .listStyle(PlainListStyle())
            .frame(minHeight: UIScreen.main.bounds.height * 0.7)
        }
        .transition(.move(edge: .bottom))
        .padding(.horizontal)
    }
    
    private var recommendedRestaurantsView: some View{
        VStack{
            HStack{
                Text("Recommended")
                    .font(.title.weight(.semibold))
                    .foregroundColor(Color.theme.accent)
                Spacer()
                Button{
                    //Do something
                }label: {
                    Text("See all")
                        .foregroundColor(Color.theme.green)
                        .font(.subheadline)
                }
            }
            .padding(.horizontal)
            Carousel(list: homeVM.restaurants, spacing: 20, trailingSpacing: 80) { restaurant in
                RestaurantBannerView(restaurant: restaurant)
            }
            .frame(height: UIScreen.main.bounds.height * 0.51)
        }
    }
    
    private var promotedRestaurantsView: some View{
        VStack{
            HStack{
                Text("Promotion")
                    .font(.title.weight(.semibold))
                    .foregroundColor(Color.theme.accent)
                Spacer()
                Button{
                    //Do something
                }label: {
                    Text("See all")
                        .foregroundColor(Color.theme.green)
                        .font(.subheadline)
                }
            }
            .padding(.horizontal)
            Carousel(list: homeVM.restaurants, spacing: 5, trailingSpacing: 55) { restaurant in
                RestaurantPromotionsView(restaurant: restaurant)
            }
            .frame(height: 200)
            .padding(.bottom)
        }
    }
    
    private var listOfRestaurants: some View{
        ForEach(homeVM.restaurants.indices, id: \.self){ index in
            RestaurantCardView(restaurant: $homeVM.restaurants[index])
                .padding(.vertical, 5)
        }
        .padding(.horizontal)
    }
}
