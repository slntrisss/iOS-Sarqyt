//
//  DetailMapView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 08.03.2023.
//

import SwiftUI
import MapKit

struct DetailMapView: View {
    @EnvironmentObject private var detailVM: RestaurantDetailViewModel
    var body: some View {
        Map(coordinateRegion: region, annotationItems: [AnnotationItem(coordinate: detailVM.restaurant.address.coordinates)]) { restaurant in
            MapAnnotation(coordinate: restaurant.coordinate) {
                RestaurantMapAnnotationView()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    private var region: Binding<MKCoordinateRegion>{
        Binding{
            detailVM.mapRegion
        }set: { newRegion in
            DispatchQueue.main.async {
                detailVM.mapRegion = newRegion
            }
        }
    }
    private var annotationItems: [AnnotationItem] {
        return [AnnotationItem(coordinate: detailVM.restaurant.address.coordinates)]
    }
}

struct DetailMapView_Previews: PreviewProvider {
    static var previews: some View {
        DetailMapView()
            .environmentObject(RestaurantDetailViewModel(restaurant: dev.restaurant))
            .padding()
    }
}
struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
