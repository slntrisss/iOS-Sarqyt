//
//  RestaurantPromotionsView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 23.02.2023.
//

import SwiftUI

struct RestaurantPromotionsView: View {
    let restaurant: Restaurant
    var body: some View {
        VStack{
            Image(restaurant.image)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: 200)
                .overlay(
                    ZStack{
                        Color.black.opacity(0.3)
                        Text(restaurant.name)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
            HStack{
                Image(systemName: "hand.thumbsup")
                Text(restaurant.rating.toPercent())
                Text(reviews)
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
                Spacer()
                Text("₸"+restaurant.reserveAmount.formattedWithAbbreviations())
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
}

struct RestaurantPromotionsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RestaurantPromotionsView(restaurant: dev.restaurant)
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            RestaurantPromotionsView(restaurant: dev.restaurant)
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension RestaurantPromotionsView{
    private var reviews: String{
        if restaurant.reviewAmount > 0{
            let count = Double(restaurant.reviewAmount)
            return "(\(count.formattedWithAbbreviations()) \(count > 1 ? "reviews" : "review"))"
        }
        return ""
    }
}
