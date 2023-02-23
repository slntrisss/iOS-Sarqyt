//
//  RestaurantCardView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 22.02.2023.
//

import SwiftUI

struct RestaurantCardView: View {
    @Binding var restaurant: Restaurant
    var body: some View {
        HStack{
            cardImage
            VStack(alignment: .leading, spacing: 10){
                descriptionRow1
                descriptionRow2
                descriptionRow3
            }
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.theme.field, lineWidth: 3))
        .background(Color.theme.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct RestaurantCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            RestaurantCardView(restaurant: .constant(dev.restaurant))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
                .padding()
            
            RestaurantCardView(restaurant: .constant(dev.restaurant))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension RestaurantCardView{
    
    private var cardImage: some View{
        Image(restaurant.image)
            .resizable()
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var descriptionRow1: some View{
        HStack{
            Text(restaurant.name)
                .font(.headline.bold())
                .foregroundColor(Color.theme.accent)
                .lineLimit(2)
            Spacer()
            Text("₸"+restaurant.reserveAmount.formattedWithAbbreviations())
                .font(.body.bold())
                .foregroundColor(Color.theme.green)
        }
    }
    
    private var descriptionRow2: some View{
        Text(restaurant.address.city)
            .font(.subheadline)
            .foregroundColor(Color.theme.secondaryText)
    }
    
    private var descriptionRow3: some View{
        HStack{
            HStack{
                ratingView
                Text(reviews)
                    .font(.caption2)
                    .foregroundColor(Color.theme.secondaryText)
            }
            Spacer()
            bookmarkButton
        }
    }
    
    private var ratingView: some View{
        HStack(spacing: 2){
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Text(restaurant.rating.asNumberStringWithOneDigit())
                .font(.subheadline.bold())
                .foregroundColor(Color.theme.green)
        }
    }
    
    private var bookmarkButton: some View{
        Button{
            restaurant.bookmarked.toggle()
        }label: {
            Image(systemName: restaurant.bookmarked ? "bookmark.fill" : "bookmark")
                .font(.subheadline.bold())
                .foregroundColor(Color.theme.green)
        }
    }
    
    private var reviews: String{
        if restaurant.reviewAmount > 0{
            let count = Double(restaurant.reviewAmount)
            return "(\(count.formattedWithAbbreviations()) \(count > 1 ? "reviews" : "review"))"
        }
        return ""
    }
}
