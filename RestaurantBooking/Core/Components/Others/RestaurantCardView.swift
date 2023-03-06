//
//  RestaurantCardView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 22.02.2023.
//

import SwiftUI

struct RestaurantCardView: View {
    @EnvironmentObject private var homeVM: HomeViewModel
    @Binding var restaurant: Restaurant
    
    @State private var showRemoveBookmarkView = false
    @State private var cancelButtonTapped = false
    @State private var removeButtonTapped = false
    
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
        .sheet(isPresented: $showRemoveBookmarkView, content: {bottomSheetView})
        .background(Color.theme.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct RestaurantCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            RestaurantCardView(restaurant: .constant(dev.restaurant))
                .environmentObject(HomeViewModel())
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
                .padding()
            
            RestaurantCardView(restaurant: .constant(dev.restaurant))
                .environmentObject(HomeViewModel())
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
            if restaurant.bookmarked{
                showRemoveBookmarkView = true
            }else{
                restaurant.bookmarked.toggle()
                homeVM.bookmarkRestaurant(restaurant: restaurant)
            }
        }label: {
            Image(systemName: restaurant.bookmarked ? "bookmark.fill" : "bookmark")
                .font(.subheadline.bold())
                .foregroundColor(Color.theme.green)
        }
    }
    
    private var bottomSheetView: some View{
        VStack{
            Capsule()
                .fill(Color.theme.secondaryText.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.bottom)
            Text("Remove from bookmark?")
                .font(.title.weight(.semibold))
                .foregroundColor(Color.theme.accent)
            Divider()
            RestaurantCardView(restaurant: $restaurant)
                .padding(.vertical)
                .disabled(true)
            HStack{
                SecondaryButton(buttonLabel: "Cancel", buttonClicked: $cancelButtonTapped)
                PrimaryButton(buttonLabel: "Yes, Remove", buttonClicked: $removeButtonTapped)
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.theme.sheetBackground.ignoresSafeArea(.all))
        .presentationDetents([.height(350)])
        .onChange(of: cancelButtonTapped) { _ in showRemoveBookmarkView = false}
        .onChange(of: removeButtonTapped) { _ in
            homeVM.removeFromBookmarked(restaurant: restaurant)
            showRemoveBookmarkView = false
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
