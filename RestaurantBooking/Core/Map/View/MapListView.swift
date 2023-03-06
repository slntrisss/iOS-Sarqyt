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
            ForEach(mapVM.restaurants){ restaurant in
                Button {
                    mapVM.showNextRestaurant(restaurant: restaurant)
                } label: {
                    listRowView(restaurant: restaurant)
                }
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
            }
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
        HStack{
            Image(restaurant.image)
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
