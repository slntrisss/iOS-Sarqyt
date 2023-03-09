//
//  RestaurantDetailViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 08.03.2023.
//

import MapKit

class RestaurantDetailViewModel: ObservableObject{
    @Published var restaurant: Restaurant
    @Published var mapRegion: MKCoordinateRegion
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    init(){
        let restaurant = DeveloperPreview.instance.restaurant
        self._restaurant = Published(initialValue: restaurant)
        let coordinates = restaurant.address.coordinates
        mapRegion = MKCoordinateRegion(center: coordinates, span: mapSpan)
    }
}
