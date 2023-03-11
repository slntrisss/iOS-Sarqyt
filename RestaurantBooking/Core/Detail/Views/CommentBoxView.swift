//
//  CommentBoxView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 11.03.2023.
//

import SwiftUI

struct CommentBoxView: View {
    @EnvironmentObject private var detailVM: RestaurantDetailViewModel
    @State private var showFullComment = false
    let comment: Comment
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading, spacing: 5){
                    Text(comment.user.firstName + " " + comment.user.lastName)
                        .font(.headline)
                    Text(comment.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                }
                Spacer()
                RestaurantRatingStarView(rating: Double(comment.rating))
            }
            VStack(alignment: .leading){
                Text(comment.text)
                    .font(.callout)
                    .foregroundColor(Color.theme.secondaryText)
                    .lineLimit(showFullComment ? nil : 1)
                Button{
                    withAnimation(.easeInOut){
                        showFullComment.toggle()
                    }
                }label: {
                    Text(showFullComment ? "Hide" : "Show more...")
                        .font(.caption)
                        .foregroundColor(Color.theme.green)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.theme.field)
        )
    }
}

struct CommentBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CommentBoxView(comment: DeveloperPreview.instance.comments.first!)
            .environmentObject(RestaurantDetailViewModel())
            .padding()
    }
}
