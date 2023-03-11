//
//  CommentView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 11.03.2023.
//

import SwiftUI

struct CommentView: View {
    @EnvironmentObject private var detailVM: RestaurantDetailViewModel
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12){
                Text("Overall Rating")
                    .font(.headline)
                ratingStatusView
                progressViews
            }
            .padding(.bottom)
            comments
        }
        .padding()
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            CommentView()
                .environmentObject(RestaurantDetailViewModel())
        }
    }
}

extension CommentView{
    
    private var comments: some View{
        LazyVStack {
            ForEach(detailVM.comments){ comment in
                CommentBoxView(comment: comment)
            }
        }
    }
    
    private var ratingStatusView: some View{
        HStack{
            VStack{
                Text(detailVM.restaurant.rating.asNumberStringWithOneDigit())
                    .font(.largeTitle.bold())
            }
            VStack(alignment: .leading){
                RestaurantRatingStarView(rating: detailVM.restaurant.rating)
                Text(detailVM.reviews)
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
    
    private var progressViews: some View{
        VStack{
            HStack{
                Text("Excellent")
                    .frame(maxWidth: .infinity, alignment: .leading)
                ProgressView(value: detailVM.getStatus(for: 5))
                    .tint(Color(#colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)))
            }
            HStack{
                Text("Very Good")
                    .frame(maxWidth: .infinity, alignment: .leading)
                ProgressView(value: detailVM.getStatus(for: 4))
                    .tint(.green)
            }
            HStack{
                Text("Good")
                    .frame(maxWidth: .infinity, alignment: .leading)
                ProgressView(value: detailVM.getStatus(for: 3))
                    .tint(Color(#colorLiteral(red: 1, green: 0.8182049394, blue: 0.3374888301, alpha: 1)))
            }
            HStack{
                Text("Unsatisfactory")
                    .frame(maxWidth: .infinity, alignment: .leading)
                ProgressView(value: detailVM.getStatus(for: 2))
                    .tint(Color(#colorLiteral(red: 1, green: 0.5463681817, blue: 0.2389869392, alpha: 1)))
            }
            HStack{
                Text("Poor")
                    .frame(maxWidth: .infinity, alignment: .leading)
                ProgressView(value: detailVM.getStatus(for: 1))
                    .tint(.red)
            }
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
    }
}
