//
//  MapViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 05.03.2023.
//

import SwiftUI
import MapKit

class MapViewModel: ObservableObject{
    //All restaurants locations
    @Published var restaurants: [Restaurant] = []
    
    //current location
    @Published var mapRestaurant: Restaurant{
        didSet{
            updateMapRegion(address: mapRestaurant.address)
        }
    }
    //Current region
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    //Show list of restaurants on map
    @Published var showListView: Bool = false
    
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    init(){
        let restaurants = DeveloperPreview.instance.restaurants
        self.restaurants = restaurants
        self.mapRestaurant = restaurants.first!
        
        self.updateMapRegion(address: restaurants.first!.address)
    }
    
    private func updateMapRegion(address: Address){
        withAnimation(.easeInOut){
            mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude), span: mapSpan)
        }
    }
    
    func toggleShowList(){
        withAnimation(.easeInOut){
            showListView.toggle()
        }
    }
    
    func showNextRestaurant(restaurant: Restaurant){
        withAnimation(.easeInOut){
            mapRestaurant = restaurant
            showListView = false
        }
    }
    
    func nextButtonTapped(){
        guard let currentIndex = restaurants.firstIndex(where: {$0 == mapRestaurant}) else{
            print("Could not find current index in restaurants array")
            return
        }
        
        let nextIndex = currentIndex + 1
        guard restaurants.indices.contains(nextIndex) else{
            // Next index not VALID
            //Restart from 0
            guard let firstRestaurant = restaurants.first else {return}
            showNextRestaurant(restaurant: firstRestaurant)
            return
        }
        
        //Next index is VALID
        let nextRestaurant = restaurants[nextIndex]
        showNextRestaurant(restaurant: nextRestaurant)
    }
}
