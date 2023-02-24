//
//  StarRatingCollectionView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 24.02.2023.
//

import SwiftUI

struct StarRatingCollectionView: View {
    let ratings: [Int]
    @Binding var selectedRating: Int
    let leadingSpacing: CGFloat
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                ForEach(ratings.indices, id: \.self) { index in
                    Button{
                        selectedRating = ratings[index]
                    }label: {
                        HStack{
                            Image(systemName: "star.fill")
                                .font(.subheadline)
                                .foregroundColor(selectedRating == ratings[index] ? Color.white : Color.theme.green)
                            Text("\(ratings[index])")
                        }
                        .font(.title3)
                        .foregroundColor(selectedRating == ratings[index] ? Color.white : Color.theme.green)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(selectedRating == ratings[index] ? Color.theme.green : Color.theme.collectionBackground)
                        )
                        .overlay(
                            Capsule()
                                .strokeBorder(Color.theme.green, lineWidth: 2)
                        )
                        .clipShape(Capsule())
                        .offset(x: leadingSpacing)
                        .padding(.trailing, index == endIndex ? leadingSpacing * 2 : 0)
                    }
                }
            }
        }
    }
}

struct StarRatingCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        StarRatingCollectionView(ratings: [1,2,3,4,5], selectedRating: .constant(1), leadingSpacing: 20)
    }
}

extension StarRatingCollectionView{
    private var endIndex: Int{
        return ratings.count - 1
    }
}
