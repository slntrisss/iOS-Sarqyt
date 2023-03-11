//
//  DetailView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 08.03.2023.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var detailVM = RestaurantDetailViewModel()
    let details: RestaurantDetails
    let restaurant: Restaurant
    @State private var showFullDescription = true
    @State private var booknowButtonPressed = false
    
    @State private var totalHeightForCategoriesList = CGFloat.zero
    init(restaurant: Restaurant){
        self.restaurant = restaurant
        details = restaurant.details
    }
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]){
                    
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
                    
                    Section(header: titleView) {
                        addressView
                        ratingsAndReviewsView
                        GeometryReader{ proxy in
                            self.generateContent(in: proxy)
                        }
                        .frame(height: totalHeightForCategoriesList)
                        descriptionView
                        DetailMapView()
                            .environmentObject(detailVM)
                        contactsView
                            .padding(.vertical)
                    }
                    .padding(.horizontal)
                }
            }
            .overlay (
                Color.theme.background
                    .frame(height: topSafeAreaInset)
                    .opacity(detailVM.mainImageOffset > 250 ? 1 : 0)
                    .ignoresSafeArea(.all, edges: .top),
                alignment: .top
            )
            bottomBar
        }
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
                .frame(width: UIScreen.main.bounds.width)
            HStack(alignment: .top){
                Button{
                    
                }label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.title3.bold())
                }
                Spacer()
                Button{
                    
                }label: {
                    Image(systemName: "bookmark")
                        .foregroundColor(.white)
                        .font(.title3.bold())
                }
            }
            .padding()
            .offset(y: 30)
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
        HStack(spacing: 0){
            Button {} label: {
                Image(systemName: "arrow.left")
                    .font(.title3.bold())
                    .frame(width: getSize(), height: getSize())
                    .opacity(getSize() > 0 ? 1.0 : 0.0)
                    .foregroundColor(Color.theme.accent)
            }
            Text(restaurant.name)
                .font(.title.weight(.semibold))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            Spacer()
            Button{
                
            }label: {
                Image(systemName: "hand.thumbsup")
            }
        }
        .padding(.horizontal)
        .background(Color.theme.background)
        .padding(.bottom, 10)
    }
    
    private func getSize() -> CGFloat{
        if detailVM.mainImageOffset > 200{
            let progress = (detailVM.mainImageOffset - 200) / 50
            return progress <= 1.0 ? (progress * 40) : 40
        }
        return 0
    }
    
    private var descriptionView: some View{
        VStack(alignment: .leading) {
            Text("Description")
                .font(.title3.weight(.medium))
            Text(details.description)
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
    
    private var contactsView: some View{
        VStack(alignment: .leading){
            Text("Contact us")
                .font(.subheadline.weight(.medium))
                .foregroundColor(Color.theme.accent.opacity(0.8))
            HStack{
                HStack{
                    Image(systemName: "phone.circle")
                        .font(.caption)
                    Text(details.phoneNumber)
                        .font(.caption2)
                }
                .foregroundColor(Color.theme.green)
                .padding(.leading)
                Spacer()
                HStack(spacing: 10){
                    if let instaLink = details.instragramLink{
                        Image("insta-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .overlay(Link("", destination: URL(string: instaLink)!))
                    }
                    if let metaLink = details.metaLink{
                        Image("meta-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .overlay(Link("", destination: URL(string: metaLink)!))
                    }
                }
                .padding(.trailing)
            }
        }
    }
    
    private var bottomBar: some View{
        HStack{
            Text("\("₸" + restaurant.reserveAmount.formattedWithAbbreviations())")
                .font(.title3.weight(.semibold))
                .foregroundColor(Color.theme.green)
                .padding(.horizontal)
            
            PrimaryButton(buttonLabel: "Book Now", buttonClicked: $booknowButtonPressed)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(.thinMaterial))
    }
    
    private var reviews: String{
        if restaurant.reviewAmount > 0{
            let count = Double(restaurant.reviewAmount)
            return "(\(count.formattedWithAbbreviations()) \(count > 1 ? "reviews" : "review"))"
        }
        return ""
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(RestaurantDetails.categories, id: \.self) { platform in
                self.item(for: platform)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width){
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if let category = RestaurantDetails.categories.last, platform == category {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if let category = RestaurantDetails.categories.last, platform == category {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeightForCategoriesList))
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View{
        return GeometryReader{ geo -> Color in
            let rect = geo.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
    
    func item(for text: String) -> some View {
        Text("•"+text)
            .padding(.trailing)
            .font(.callout)
            .foregroundColor(Color.theme.secondaryText)
    }
    
    private var topSafeAreaInset: CGFloat?{
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topWindow = windowScene.windows.first {
            return topWindow.safeAreaInsets.top
        }
        return nil
    }
}
