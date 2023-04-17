//
//  RestaurantListView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 24.02.2023.
//

import SwiftUI

struct RestaurantListView: View {
    @EnvironmentObject private var homeVM: HomeViewModel
    @StateObject private var listVM: RestaurantListViewModel
    let title: String
    init(title: String, listType: RestaurantListViewModel.RestaurantListType){
        self.title = title
        self._listVM = StateObject(wrappedValue: RestaurantListViewModel(listType: listType))
    }
    var body: some View {
        ScrollView(.vertical, showsIndicators: true){
            LazyVStack{
                ForEach(listVM.restaurants.indices, id: \.self) { index in
                    RestaurantCardView(restaurant: $listVM.restaurants[index])
                        .environmentObject(homeVM)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .transition(.move(edge: .leading))
                        .onAppear{
                            listVM.requestMoreItems(index: index)
                        }
                }
            }
            .animation(.easeOut, value: homeVM.restaurants)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .refreshable {
            listVM.refreshList()
        }
    }
}

struct RestaurantListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            RestaurantListView(title: "My Bookmarked", listType: .recommended)
                .environmentObject(HomeViewModel())
        }
    }
}
