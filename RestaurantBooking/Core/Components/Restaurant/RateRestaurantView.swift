//
//  RateRestaurantView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 02.04.2023.
//

import SwiftUI

struct RateRestaurantView: View {
    let restaurant: Restaurant
    @State private var selectedStars = -1
    @Binding var comment: String
    @Binding var rate: Bool
    @Binding var cancelRating: Bool
    var body: some View {
        ScrollView(.vertical){
            VStack{
                Capsule().fill(Color.theme.secondaryText.opacity(0.5))
                    .frame(width: 40, height: 5)
                Text("Rate the Restaurant")
                    .font(.title3.weight(.semibold))
                Divider()
                restaurantCardView
                Spacer().frame(height: 30)
                ratedStarsView
                Spacer().frame(height: 30)
                commentView
                Spacer().frame(height: 30)
                VStack(spacing: 20){
                    PrimaryButton(buttonLabel: "Rate now", buttonClicked: $rate)
                    SecondaryButton(buttonLabel: "Later", buttonClicked: $cancelRating)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct RateRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        RateRestaurantView(restaurant: dev.restaurant,
                           comment: .constant(""),
                           rate: .constant(false),
                           cancelRating: .constant(false))
    }
}
extension RateRestaurantView{
    private var restaurantCardView: some View{
        VStack{
            HStack{
                cardImage
                VStack(alignment: .leading, spacing: 10){
                    Text(restaurant.name)
                        .font(.headline.bold())
                        .foregroundColor(Color.theme.accent)
                        .lineLimit(1)
                    Text(restaurant.address.city)
                        .font(.subheadline)
                        .foregroundColor(Color.theme.secondaryText)
                    ratingView
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.theme.field))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.sheetBackground.ignoresSafeArea(.all))
        .presentationDetents([.height(350)])
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
    private var cardImage: some View{
        Image(restaurant.image)
            .resizable()
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    private var ratedStarsView: some View{
        Group{
            Text("Please give your rating & review")
                .font(.headline.weight(.semibold))
            HStack{
                ForEach(0..<5, id: \.self){ i in
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(self.selectedStars >= i ? Color.theme.yellowColor : Color.theme.secondaryText.opacity(0.5))
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            self.selectedStars = i
                        }
                }
            }
        }
    }
    private var commentView: some View{
        TextEditor(text: $comment)
            .frame(height: 150)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.theme.secondaryText.opacity(0.5))
            )
    }
}
