//
//  DetailView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 08.03.2023.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var detailVM = RestaurantDetailViewModel()
    @StateObject private var bookVM = BookViewModel()
    let details: RestaurantDetails
    let restaurant: Restaurant
    @State private var showFullDescription = false
    @State private var showMenu = false
    @State private var totalHeightForCategoriesList = CGFloat.zero
    init(restaurant: Restaurant){
        self.restaurant = restaurant
        details = restaurant.details
        bookVM.setupRestaurant(restaurant: restaurant)
    }
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]){
                    scrollableImage
                    contentView
                }
            }
            .overlay (titleBackgroundView, alignment: .top)
            bottomBar
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationDestination(isPresented: $detailVM.showAllReviews) {CommentView().environmentObject(detailVM)}
        .navigationDestination(isPresented: $showMenu)
        {FoodView(title: restaurant.name, bookVM: bookVM)}
            .navigationDestination(isPresented: $detailVM.bookNow){RestaurantBookingView(bookVM: bookVM)}
        .background(Color.theme.background)
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
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .font(.headline.weight(.heavy))
                        .foregroundColor(Color.white.opacity(0.8))
                        .padding()
                }
                Spacer()
                HStack(spacing: 0){
                    Button{
                        
                    }label: {
                        Image(systemName: "hand.thumbsup")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .font(.headline.weight(.heavy))
                            .foregroundColor(Color.white.opacity(0.8))
                            .padding()
                    }
                    
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
            .padding()
            .offset(y: 30)
        }
    }
    
    private var scrollableImage: some View{
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
    }
    
    private var contentView: some View{
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
            reviewsView
        }
        .padding(.horizontal)
    }
    
    private var ratingsAndReviewsView: some View{
        HStack{
            RestaurantRatingStarView(rating: restaurant.rating)
            Text("\(restaurant.rating.asNumberStringWithOneDigit())")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(detailVM.reviews)
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
                    .frame(width: detailVM.getSize(), height: detailVM.getSize())
                    .opacity(detailVM.getSize() > 0 ? 1.0 : 0.0)
                    .foregroundColor(Color.theme.accent)
            }
            Text(restaurant.name)
                .font(.title.weight(.semibold))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            Spacer()
            Button{
                showMenu.toggle()
            }label: {
                HStack{
                    Text("Menu")
                    Image(systemName: "text.book.closed")
                }
            }
        }
        .padding(.horizontal)
        .background(Color.theme.background)
        .padding(.bottom, 10)
    }
    
    private var titleBackgroundView: some View{
        Color.theme.background
            .frame(height: detailVM.topSafeAreaInset)
            .opacity(detailVM.mainImageOffset > 250 ? 1 : 0)
            .ignoresSafeArea(.all, edges: .top)
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
    
    private var reviewsView: some View{
        VStack{
            HStack{
                Text("Reviews")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(Color.theme.accent.opacity(0.8))
                Text(detailVM.reviews)
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
                Spacer()
                Button{
                    detailVM.showAllReviews.toggle()
                }label: {
                    Text("See all")
                        .font(.caption)
                        .foregroundColor(Color.theme.green)
                }
            }
            
            ForEach(detailVM.comments){ comment in
                CommentBoxView(comment: comment)
                    .environmentObject(detailVM)
                    .padding(.vertical, 5)
            }
        }
    }
    
    private var bottomBar: some View{
        HStack{
            Text("\("₸" + restaurant.reserveAmount.formattedWithAbbreviations())")
                .font(.title3.weight(.semibold))
                .foregroundColor(Color.theme.green)
                .padding(.horizontal)
            
            PrimaryButton(buttonLabel: "Book Now", buttonClicked: $detailVM.bookNow)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(.thinMaterial))
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
}
