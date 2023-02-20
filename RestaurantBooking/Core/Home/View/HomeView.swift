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
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
                SearchFieldView(searchQuery: $homeVM.searchQuery, searchFieldInFocus: $searchFieldInFocus)
                    .padding()
                CategoryCollectionView(collections: homeVM.categories, selectedCollection: $homeVM.selectedCategory)
                    .padding(.leading)
                    .padding(.bottom)
                if searchFieldInFocus{
                    seacrhResultView
                }
            }
            .navigationTitle("Hello, Raim 👋")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {navLeadingItems}
                ToolbarItem(placement: .navigationBarTrailing) {navTrailingItems}
            }
        }
        .navigationViewStyle(.stack)
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
            }label: {
                Image(systemName: "bookmark")
            }
        }
    }
    
    private var seacrhResultView: some View{
        VStack(alignment: .leading){
            Divider()
            HStack{
                Text("Recent")
                    .foregroundColor(Color.theme.accent)
                    .font(.caption.bold())
                Spacer()
            }
            .padding(.top)
            ForEach(homeVM.restaurants) { restaurant in
                HStack{
                    VStack(alignment: .leading, spacing: 5){
                        Text(restaurant.name)
                            .foregroundColor(Color.theme.accent.opacity(0.95))
                        Text(restaurant.address)
                            .font(.caption2)
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .padding(.vertical)
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.theme.secondaryText)
                }
                Divider()
            }
            .onDelete(perform: homeVM.deleteSearchHistory)
        }
        .transition(.move(edge: .leading))
        .padding(.horizontal)
    }
}
