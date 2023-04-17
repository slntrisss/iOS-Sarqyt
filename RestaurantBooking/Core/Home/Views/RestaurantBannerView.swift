//
//  RestaurantBannerView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import SwiftUI

struct RestaurantBannerView: View {
    let restaurant: Restaurant
    var body: some View {
        Image(uiImage: restaurant.wrappedImage)
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.5)
            .overlay(content)
            .clipShape(RoundedRectangle(cornerRadius: 50))
    }
}

struct RestaurantBannerView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantBannerView(restaurant: dev.restaurant)
    }
}

extension RestaurantBannerView{
    
    private var content: some View{
        ZStack{
            Color.black.opacity(0.3)
            VStack(alignment: .leading){
                ratingView
                Spacer()
                VStack(alignment: .leading, spacing: 10){
                    Text(restaurant.name)
                        .font(.title3.bold())
                    addressView
                    Text("₸"+restaurant.reserveAmount.formattedWithAbbreviations())
                        .font(.headline)
                }
            }
            .foregroundColor(.white)
            .padding(30)
        }
    }
    
    private var ratingView: some View{
        HStack{
            Spacer()
            HStack{
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 10, height: 10)
                Text(restaurant.rating.asNumberStringWithOneDigit())
            }
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color.theme.green)
            )
        }
    }
    
    private var addressView: some View{
        HStack{
            Image(systemName: "mappin.and.ellipse")
            Text("\(restaurant.address.city), \(restaurant.address.location)")
                .lineLimit(2)
                .minimumScaleFactor(0.5)
        }
        .font(.caption2)
        .foregroundColor(.white.opacity(0.8))
    }
}
