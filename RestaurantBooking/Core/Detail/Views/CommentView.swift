//
//  CommentView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 11.03.2023.
//

import SwiftUI

struct CommentView: View {
    @StateObject private var commentVM: CommentViewModel
    let restaurant: Restaurant
    init(restaurant: Restaurant, commentRatingStatus: [Double]) {
        self.restaurant = restaurant
        self._commentVM = StateObject(wrappedValue: CommentViewModel(restaurant: restaurant, commentRatingStatus: commentRatingStatus))
        
    }
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(alignment: .leading, spacing: 12){
                Text("Overall Rating")
                    .font(.headline)
                ratingStatusView
                progressViews
            }
            .padding(.bottom)
            if commentVM.isLoading{
                ProgressView()
            }else{
                comments
            }
        }
        .refreshable {
            commentVM.refreshComments()
        }
        .padding()
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            CommentView(restaurant: dev.restaurant, commentRatingStatus: [])
        }
    }
}

extension CommentView{
    
    private var comments: some View{
        LazyVStack {
            ForEach(commentVM.comments.indices, id: \.self){ index in
                CommentBoxView(comment: commentVM.comments[index])
                    .onAppear{
                        commentVM.fetchMoreComments(index: index)
                    }
            }
        }
    }
    
    private var ratingStatusView: some View{
        HStack{
            VStack{
                Text(restaurant.rating.asNumberStringWithOneDigit())
                    .font(.largeTitle.bold())
            }
            VStack(alignment: .leading){
                RestaurantRatingStarView(rating: restaurant.rating)
                Text(commentVM.reviews)
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
    
    private var progressViews: some View{
        LazyVStack{
            HStack{
                Text("Excellent")
                    .frame(maxWidth: .infinity, alignment: .leading)
                ProgressView(value: commentVM.getStatus(for: 5))
                    .tint(Color(#colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)))
            }
            HStack{
                Text("Very Good")
                    .frame(maxWidth: .infinity, alignment: .leading)
                ProgressView(value: commentVM.getStatus(for: 4))
                    .tint(.green)
            }
            HStack{
                Text("Good")
                    .frame(maxWidth: .infinity, alignment: .leading)
                ProgressView(value: commentVM.getStatus(for: 3))
                    .tint(Color(#colorLiteral(red: 1, green: 0.8182049394, blue: 0.3374888301, alpha: 1)))
            }
            HStack{
                Text("Unsatisfactory")
                    .frame(maxWidth: .infinity, alignment: .leading)
                ProgressView(value: commentVM.getStatus(for: 2))
                    .tint(Color(#colorLiteral(red: 1, green: 0.5463681817, blue: 0.2389869392, alpha: 1)))
            }
            HStack{
                Text("Poor")
                    .frame(maxWidth: .infinity, alignment: .leading)
                ProgressView(value: commentVM.getStatus(for: 1))
                    .tint(.red)
            }
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
    }
}
