//
//  DetailView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 08.03.2023.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var detailVM = RestaurantDetailViewModel()
    let restaurant: Restaurant
    @State private var showFullDescription = false
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            mainImage
            VStack(alignment: .leading){
                titleView
                addressView
                ratingsAndReviewsView
                descriptionView
                HStack{
                    HStack{
                        Image(systemName: "phone.circle")
                    }
                }
                DetailMapView()
                    .environmentObject(detailVM)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {navBookmarkButton}
            ToolbarItem(placement: .navigationBarLeading) {navBackButton}
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            DetailView(restaurant: DeveloperPreview.instance.restaurant)
        }
    }
}

extension DetailView{
    
    private var mainImage: some View{
        ZStack(alignment: .top){
            Image(restaurant.image)
                .resizable()
                .scaledToFill()
                .overlay(Color.black.opacity(0.25))
                .frame(maxWidth: .infinity)
        }
    }
    
    private var navBackButton: some View{
        HStack{
            Button{
                
            }label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .font(.headline.weight(.heavy))
                    .foregroundColor(Color.white.opacity(0.8))
                    .clipShape(Circle())
                    .padding()
            }
            Spacer()
        }
    }
    
    private var navBookmarkButton: some View{
        HStack{
            Spacer()
            Button{
                
            }label: {
                Image(systemName: "bookmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .font(.headline.weight(.heavy))
                    .foregroundColor(Color.white.opacity(0.8))
                    .padding()
            }
        }
    }
    
    private var ratingsAndReviewsView: some View{
        HStack{
            RestaurantRatingStarView(rating: restaurant.rating)
            Text("\(restaurant.rating.asNumberStringWithOneDigit())")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(reviews)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
        }
    }
    
    private var addressView: some View{
        HStack{
            Image(systemName: "mappin.and.ellipse")
                .foregroundColor(Color.theme.green)
            Text("\(restaurant.address.city), \(restaurant.address.location)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
        }
    }
    
    private var titleView: some View{
        HStack{
            Text(restaurant.name)
                .font(.largeTitle.weight(.semibold))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            Spacer()
            Button{
                
            }label: {
                Image(systemName: "hand.thumbsup")
            }
        }
        .padding(.bottom)
    }
    
    private var descriptionView: some View{
        VStack(alignment: .leading) {
            Text("Description")
                .font(.title3.weight(.medium))
            Text(restaurant.details.description)
                .lineLimit(showFullDescription ? nil : 3)
                .font(.callout)
            .foregroundColor(Color.theme.secondaryText)
            .padding(.top)
            .padding(.horizontal)
            
            Button{
                withAnimation(.easeOut){
                    showFullDescription.toggle()
                }
            }label: {
                Text(showFullDescription ? "Less" : "Read more..")
                    .font(.caption)
                    .bold()
            }
            .tint(Color.theme.green)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical)
    }
    
    private var reviews: String{
        if restaurant.reviewAmount > 0{
            let count = Double(restaurant.reviewAmount)
            return "(\(count.formattedWithAbbreviations()) \(count > 1 ? "reviews" : "review"))"
        }
        return ""
    }
}
