//
//  RestaurantLocationPreview.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 05.03.2023.
//

import SwiftUI

struct RestaurantLocationPreview: View {
    @EnvironmentObject private var mapVM: MapViewModel
    let restaurant: Restaurant
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 16){
                imageSection
                titleSection
            }
            
            VStack(spacing: 8){
                learnMoreButton
                nextButton
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .offset(y: 65)
        )
        .cornerRadius(10)
    }
}

struct RestaurantLocationPreview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            RestaurantLocationPreview(restaurant: dev.restaurant)
                .environmentObject(MapViewModel())
                .padding()
        }
    }
}

extension RestaurantLocationPreview{
    
    private var imageSection: some View{
        ZStack{
            Image(restaurant.image)
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private var titleSection: some View{
        VStack(alignment: .leading, spacing: 4) {
            Text(restaurant.name)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(restaurant.address.city)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var learnMoreButton: some View{
        Button {
            
        } label: {
            Text("Learn more")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.borderedProminent)
        .tint(Color.theme.green)
    }
    
    private var nextButton: some View{
        Button {
            mapVM.nextButtonTapped()
        } label: {
            Text("Next")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.bordered)
    }
}
