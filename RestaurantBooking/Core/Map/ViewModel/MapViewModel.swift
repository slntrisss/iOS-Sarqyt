//
//  MapViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 05.03.2023.
//

import SwiftUI
import MapKit
import Combine

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var restaurants: [Restaurant] = []
    @Published var mapRestaurant: Restaurant? = nil
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    @Published var showListView: Bool = false
    @Published var navigateToDetailView = false
    
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    var locationManager: CLLocationManager?
    
    let dataService = MapDataService.instance
    let pageInfo = PageInfo(itemsLoaded: 0)
    var cancellables = Set<AnyCancellable>()
    
    //MARK: Loading view
    @Published var isListLoading = true
    let placeholder = DeveloperPreview.instance.restaurants
    override init(){
        super.init()
        addSubscribers()
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
            updateMapRegion(address: restaurant.address)
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
    
    //MARK: - User Location
    
    func checkIfLocationServiceIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            //TODO: alert for enabling location
            
        }
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //TODO: alert
            print("Your location is restricted.")
        case .denied:
            //TODO: alert
            print("Your location is denied. Go to settings and enable location")
        case .authorizedAlways, .authorizedWhenInUse:
            mapRegion = MKCoordinateRegion(center: locationManager.location?.coordinate ?? mapRegion.center, span: mapSpan)
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    //MARK: - Networking
    
    private func addSubscribers(){
        dataService.$restaurants
            .sink { [weak self] fetchedRestaurants in
                if let fetchedRestaurants = fetchedRestaurants{
                    self?.isListLoading = false
                    self?.restaurants.append(contentsOf: fetchedRestaurants)
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchRestaurants(offset: Int = Constants.DEFAULT_OFFSET, limit: Int = Constants.DEFAULT_LIMIT, index: Int = 0){
        if restaurants.count == 0{
            dataService.fetchRestaurants(offset: offset, limit: limit)
        } else if index == restaurants.count - 1{
            pageInfo.offset += Constants.DEFAULT_LIMIT
            dataService.fetchRestaurants(offset: pageInfo.offset, limit: Constants.DEFAULT_LIMIT)
        }
    }
    
    func refreshItems(){
        isListLoading = true
        restaurants.removeAll()
        pageInfo.offset = 0
        dataService.fetchRestaurants(offset: Constants.DEFAULT_OFFSET + 5, limit: Constants.DEFAULT_LIMIT)
    }
}
