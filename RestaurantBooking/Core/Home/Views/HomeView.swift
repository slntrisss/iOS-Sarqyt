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
    @State private var showFilterView = false
    var body: some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false) {
                SearchFieldView(searchQuery: $homeVM.searchQuery, searchFieldInFocus: $searchFieldInFocus, showFilterView: $showFilterView)
                    .padding()
                ZStack{
                    if searchFieldInFocus && !homeVM.recentSearchHistory.isEmpty{
                        seacrhResultView
                    }else{
                        LazyVStack{
                            recommendedRestaurantsView
                            promotedRestaurantsView
                            listOfRestaurants
                        }
                    }
                }
            }
            .refreshable {
                homeVM.refreshHomeViewData()
            }
            .scrollDismissesKeyboard(.immediately)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {navLeadingItems}
                ToolbarItem(placement: .navigationBarTrailing) {navTrailingItems}
            }
            .navigationDestination(isPresented: $homeVM.showRecommended) {
                RestaurantListView(title: "Recommended", listType: .recommended)
                    .environmentObject(homeVM)
            }
            .navigationDestination(isPresented: $homeVM.showPromoted) {
                RestaurantListView(title: "Promoted", listType: .promoted)
                    .environmentObject(homeVM)
            }
            .navigationDestination(isPresented: $homeVM.showBookmarked) {
                RestaurantListView(title: "Bookmarked", listType: .bookmarked)
                    .environmentObject(homeVM)
            }
            .navigationDestination(isPresented: $homeVM.showRestaurantDetailView, destination: {
                if let restaurant = homeVM.selectedRestaurant{
                    DetailView(restaurant: restaurant)
                }
            })
            .sheet(isPresented: $showFilterView) {
                FilterView()
                    .environmentObject(homeVM.filterVM)
            }
            .onAppear{
                homeVM.addSubscribers()
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
                homeVM.getBookmarkedRestaurants()
                homeVM.showBookmarked.toggle()
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
                    homeVM.getRecommnededRestaurants()
                    homeVM.showRecommended = true
                }label: {
                    Text("See all")
                        .foregroundColor(Color.theme.green)
                        .font(.subheadline)
                }
            }
            .padding(.horizontal)
            if homeVM.isRecommendedRestaurantsLoading{
                Carousel(list: homeVM.placeHolderArray, spacing: 20, trailingSpacing: 80) { restaurant in
                    RestaurantBannerView(restaurant: restaurant)
                }
                .frame(height: UIScreen.main.bounds.height * 0.51)
                .redacted(reason: .placeholder)
                .shimmering()
            }else{
                Carousel(list: homeVM.recommendedRestaurants, spacing: 20, trailingSpacing: 80) { restaurant in
                    RestaurantBannerView(restaurant: restaurant)
                        .onTapGesture {
                            homeVM.showRestaurantDetailView = true
                            homeVM.selectedRestaurant = restaurant
                        }
                }
                .frame(height: UIScreen.main.bounds.height * 0.51)
            }
            
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
                    homeVM.getRecommnededRestaurants()
                    homeVM.showRecommended.toggle()
                }label: {
                    Text("See all")
                        .foregroundColor(Color.theme.green)
                        .font(.subheadline)
                }
            }
            .padding(.horizontal)
            if homeVM.isPromotedRestaurantsLoading{
                Carousel(list: homeVM.placeHolderArray, spacing: 5, trailingSpacing: 55) { restaurant in
                    RestaurantPromotionsView(restaurant: restaurant)
                        .redacted(reason: .placeholder)
                        .shimmering()
                }
                .frame(height: 200)
                .padding(.bottom)
            }else{
                Carousel(list: homeVM.promotedRestaurants, spacing: 5, trailingSpacing: 55) { restaurant in
                    RestaurantPromotionsView(restaurant: restaurant)
                        .onTapGesture {
                            homeVM.showRestaurantDetailView = true
                            homeVM.selectedRestaurant = restaurant
                        }
                }
                .frame(height: 200)
                .padding(.bottom)
            }
        }
    }
    
    private var listOfRestaurants: some View{
        ForEach(homeVM.isRestaurantListLoading ? homeVM.placeHolderArray.indices : homeVM.allRestaurants.indices, id: \.self){ index in
            if homeVM.isRestaurantListLoading{
                RestaurantCardView(restaurant: $homeVM.placeHolderArray[index])
                    .environmentObject(homeVM)
                    .padding(.vertical, 5)
                    .redacted(reason: .placeholder)
                    .shimmering()
            }else{
                RestaurantCardView(restaurant: $homeVM.allRestaurants[index])
                    .environmentObject(homeVM)
                    .padding(.vertical, 5)
                    .onAppear{
                        homeVM.requestMoreItems(index: index)
                    }
            }
        }
        .padding(.horizontal)
    }
}
