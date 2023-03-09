//
//  RestaurantMapAnnotationView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 06.03.2023.
//

import SwiftUI

struct RestaurantMapAnnotationView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .font(.headline)
                .foregroundColor(.white)
                .padding(6)
                .background(Color.theme.green)
                .clipShape(Circle())
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .foregroundColor(Color.theme.green)
                .rotationEffect(.degrees(180))
                .offset(y: -3)
                .padding(.bottom, 40)
        }
    }
}

struct RestaurantMapAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            RestaurantMapAnnotationView()
        }
    }
}
