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
            Map(coordinateRegion: $mapVM.mapRegion,
                annotationItems: mapVM.restaurants) { restaurant in
                MapAnnotation(coordinate: restaurant.address.coordinates) {
                    RestaurantMapAnnotationView()
                        .scaleEffect(mapVM.mapRestaurant == restaurant ? 1.0 : 0.8)
                        .shadow(radius: 10)
                        .onTapGesture {
                            mapVM.showNextRestaurant(restaurant: restaurant)
                        }
                }
            }
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
                HStack{
                    Image(systemName: "arrow.down")
                        .font(.headline)
                        .foregroundColor(Color.theme.accent)
                        .rotationEffect(.degrees(mapVM.showListView ? 180 : 0))
                        .padding()
                    
                    Text(mapVM.mapRestaurant.name + ", " + mapVM.mapRestaurant.address.city)
                        .font(.title3)
                        .fontWeight(.black)
                        .foregroundColor(Color.theme.accent)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .padding(.horizontal)
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
