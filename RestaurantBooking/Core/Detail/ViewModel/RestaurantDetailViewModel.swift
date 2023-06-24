//
//  RestaurantDetailViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 08.03.2023.
//

import MapKit
import SwiftUI
import Combine

@MainActor
class RestaurantDetailViewModel: ObservableObject{
    @Published var restaurant: Restaurant
    @Published var details: RestaurantDetails?
    @Published var comments: [Comment] = []
    @Published var mapRegion: MKCoordinateRegion
    @Published var bookNow = false
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    @Published var mainImageOffset: CGFloat = 0
    @Published var showAllReviews = false
    
    @Published var animateRestaurantTitleScroll = false
    
    @Published var showRateView = false
    @Published var comment = ""
    @Published var selectedStars = -1
    @Published var rate = false
    
    let detailsDataService = RestaurantDetailDataService.instance
    
    var cancellables = Set<AnyCancellable>()
    
    //MARK: Loading view
    @Published var isDetailsLoading = true
    @Published var isCommentListLoading = true
    
    init(restaurant: Restaurant){
        
        self._restaurant = Published(initialValue: restaurant)
        let coordinates = restaurant.address.coordinates
        mapRegion = MKCoordinateRegion(center: coordinates, span: mapSpan)

    }
    
    var topSafeAreaInset: CGFloat? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topWindow = windowScene.windows.first {
            return topWindow.safeAreaInsets.top
        }
        return nil
    }
    
    var reviews: String{
        if restaurant.reviewAmount > 0{
            let count = Double(restaurant.reviewAmount)
            return "(\(count.formattedWithAbbreviations()) \(count > 1 ? "reviews" : "review"))"
        }
        return ""
    }
    
    func getSize() -> CGFloat{
        if mainImageOffset > 200{
            let progress = (mainImageOffset - 200) / 50
            return progress <= 1.0 ? (progress * 40) : 40
        }
        return 0
    }
    
    func getStatus(for rating: Int) -> Double{
        switch rating{
        case 5:return details?.commentRatingStatus[0] ?? 0
        case 4:return details?.commentRatingStatus[1] ?? 0
        case 3:return details?.commentRatingStatus[2] ?? 0
        case 2:return details?.commentRatingStatus[3] ?? 0
        case 1:return details?.commentRatingStatus[4] ?? 0
        default:return 0
        }
    }
    
    var restaurantTitleLeftOffsetAnimation: CGFloat{
        let width = restaurant.name.widthOfString(usingFont: UIFont.preferedFont(from: .title.weight(.semibold)))
        return width > 180 ? width * CGFloat(-4) : 0
    }
    
    var restaurantTitleRightOffsetAnimation: CGFloat{
        let width = restaurant.name.widthOfString(usingFont: UIFont.preferedFont(from: .title.weight(.semibold)))
        return width > 180 ? width * CGFloat(4) : 0
    }
    
    //MARK: - Networking
    func getRestaurantDetails(for id: String){
        print("Getting detail data...")
        detailsDataService.fetchDetail(for: id)
        detailsDataService.fetchPreviewComments(for: id, offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
        
        detailsDataService.$details
            .sink { [weak self] fetchedDetails in
                if let fetchedDetails = fetchedDetails{
                    self?.isDetailsLoading = false
                    self?.details = fetchedDetails
                }
            }
            .store(in: &cancellables)
        
        detailsDataService.$previewComments
            .sink { [weak self] fetchedPreviewComments in
                if let fetchedPreviewComments = fetchedPreviewComments{
                    self?.isCommentListLoading = false
                    self?.comments = fetchedPreviewComments
                }
            }
            .store(in: &cancellables)
    }
    
    func rateRestaurant(){
        let ratedRestaurant = RatedRestaurantData(id: UUID().uuidString, restaurantId: restaurant.id, selectedStars: selectedStars, comment: comment)
        detailsDataService.rateRestaurant(for: restaurant.id, ratedRestaurantData: ratedRestaurant)
        detailsDataService.$ratedRestaurant
            .sink { [weak self] fetchedRatedRestaurant in
                if fetchedRatedRestaurant != nil{
                    self?.rate.toggle()
                    self?.showRateView.toggle()
                }
            }
            .store(in: &cancellables)
    }
}
