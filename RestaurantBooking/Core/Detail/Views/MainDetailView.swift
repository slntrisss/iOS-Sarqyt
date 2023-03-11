//
//  MainDetailView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 11.03.2023.
//

import SwiftUI

struct MainDetailView: View {
    @StateObject private var detailVM = RestaurantDetailViewModel()
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                
                GeometryReader{ proxy -> AnyView in
                    let offset = proxy.frame(in: .global).minY
                    if -offset >= 0{
                        DispatchQueue.main.async {
                            detailVM.mainImageOffset = -offset
                        }
                    }
                    return AnyView(
                        mainImage
                            .frame(height: 250 + (offset > 0 ? offset : 0))
                            .cornerRadius(2)
                            .offset(y: (offset > 0 ? -offset : 0))
                    )
                }
                .frame(height: 250)
                
                Section(header: headerView){
                    Text(detailVM.restaurant.details.description)
                    Text(detailVM.restaurant.details.description)
                }
            }
        }
        .overlay (
            Color.theme.background
                .frame(height: topSafeAreaInset)
                .opacity(detailVM.mainImageOffset > 250 ? 1 : 0)
                .ignoresSafeArea(.all, edges: .top),
            alignment: .top
        )
    }
}

struct MainDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MainDetailView()
    }
}

extension MainDetailView{
    private var headerView: some View{
        VStack(alignment: .leading){
            titleView
            addressView
            ratingsAndReviewsView
        }
        .padding(.horizontal)
        .background(Color.theme.background)
    }
    
    private func getSize() -> CGFloat{
        if detailVM.mainImageOffset > 200{
            let progress = (detailVM.mainImageOffset - 200) / 50
            return progress <= 1.0 ? (progress * 40) : 40
        }
        return 0
    }
    
    private var mainImage: some View{
        ZStack(alignment: .top){
            Image(detailVM.restaurant.image)
                .resizable()
                .scaledToFill()
                .overlay(Color.black.opacity(0.25))
                .frame(width: UIScreen.main.bounds.width)
        }
    }
    
    private var ratingsAndReviewsView: some View{
        HStack{
            RestaurantRatingStarView(rating: detailVM.restaurant.rating)
            Text("\(detailVM.restaurant.rating.asNumberStringWithOneDigit())")
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
            Text("\(detailVM.restaurant.address.city), \(detailVM.restaurant.address.location)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
        }
    }
    
    private var titleView: some View{
        HStack(spacing: 0){
            Button {} label: {
                Image(systemName: "arrow.left")
                    .font(.title3.bold())
                    .frame(width: getSize(), height: getSize())
                    .opacity(getSize() > 0 ? 1.0 : 0.0)
                    .foregroundColor(Color.theme.accent)
            }

            Text(detailVM.restaurant.name)
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
    
    private var reviews: String{
        if detailVM.restaurant.reviewAmount > 0{
            let count = Double(detailVM.restaurant.reviewAmount)
            return "(\(count.formattedWithAbbreviations()) \(count > 1 ? "reviews" : "review"))"
        }
        return ""
    }
    
    private var topSafeAreaInset: CGFloat?{
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topWindow = windowScene.windows.first {
            return topWindow.safeAreaInsets.top
        }
        return nil
    }
}
