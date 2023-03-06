//
//  MapView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var mapVM = MapViewModel()
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $mapVM.mapRegion)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                header
                    .padding()
                
                Spacer()
                
                ZStack{
                    ForEach(mapVM.restaurants) { restaurant in
                        if mapVM.mapRestaurant == restaurant{
                            RestaurantLocationPreview(restaurant: restaurant)
                                .environmentObject(mapVM)
                                .shadow(color: Color.black.opacity(0.3), radius: 20)
                                .padding()
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing),
                                    removal: .move(edge: .leading)))
                        }
                    }
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

extension MapView{
    
    private var header: some View{
        VStack {
            Button(action: mapVM.toggleShowList) {
                Text(mapVM.mapRestaurant.name + ", " + mapVM.mapRestaurant.address.city)
                    .font(.title3)
                    .fontWeight(.black)
                    .foregroundColor(Color.theme.accent)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundColor(Color.theme.accent)
                            .rotationEffect(.degrees(mapVM.showListView ? 180 : 0))
                            .padding()
                    }
            }
            if mapVM.showListView{
                MapListView()
                    .environmentObject(mapVM)
            }
        }
        .background(.thinMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
}
