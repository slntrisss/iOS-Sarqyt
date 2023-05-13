//
//  MapListView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 05.03.2023.
//

import SwiftUI

struct MapListView: View {
    @EnvironmentObject private var mapVM: MapViewModel
    var body: some View {
        List{
            ForEach(mapVM.isListLoading ? mapVM.placeholder.indices : mapVM.restaurants.indices, id: \.self){ index in
                Button {
                    mapVM.showNextRestaurant(restaurant: mapVM.restaurants[index])
                } label: {
                    listRowView(restaurant: mapVM.isListLoading ? mapVM.placeholder[index] : mapVM.restaurants[index])
                        .redacted(reason: mapVM.isListLoading ? .placeholder : [])
                        .shimmering(active: mapVM.isListLoading)
                        .onAppear{
                            if !mapVM.isListLoading{
                                mapVM.fetchRestaurants(index: index)
                            }
                        }
                }
                .disabled(mapVM.isListLoading)
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
            }
        }
        .refreshable {
            mapVM.refreshItems()
        }
        .listStyle(PlainListStyle())
    }
}

struct MapListView_Previews: PreviewProvider {
    static var previews: some View {
        MapListView()
            .environmentObject(MapViewModel())
    }
}


extension MapListView{
    private func listRowView(restaurant: Restaurant) -> some View{
        LazyHStack{
            Image(uiImage: restaurant.wrappedImage)
                .resizable()
                .scaledToFill()
                .frame(width: 45, height: 45)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.headline)
                Text(restaurant.address.city)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
