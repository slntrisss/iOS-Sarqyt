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
        Map(coordinateRegion: $detailVM.mapRegion, annotationItems: [detailVM.restaurant]) { restaurant in
            MapAnnotation(coordinate: restaurant.address.coordinates) {
                RestaurantMapAnnotationView()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct DetailMapView_Previews: PreviewProvider {
    static var previews: some View {
        DetailMapView()
            .environmentObject(RestaurantDetailViewModel())
            .padding()
    }
}
struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
