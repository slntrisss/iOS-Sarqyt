//
//  CommentViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.04.2023.
//

import Foundation
import Combine

class CommentViewModel: ObservableObject{
    @Published var comments: [Comment] = []
    let restaurant: Restaurant
    let commentRatingStatus: [Double]
    let pageInfo = PageInfo(itemsLoaded: 0)
    let detailDataService = RestaurantDetailDataService.instance
    var cancellables = Set<AnyCancellable>()
    
    //MARK: Loading view
    @Published var isLoading = true
    
    init(restaurant: Restaurant, commentRatingStatus: [Double]){
        self.restaurant = restaurant
        self.commentRatingStatus = commentRatingStatus
        fetchComments()
    }
    
    func getStatus(for rating: Int) -> Double{
        switch rating{
        case 5:return commentRatingStatus[0]
        case 4:return commentRatingStatus[1]
        case 3:return commentRatingStatus[2]
        case 2:return commentRatingStatus[3]
        case 1:return commentRatingStatus[4]
        default:return 0
        }
    }
    
    var reviews: String{
        if restaurant.reviewAmount > 0{
            let count = Double(restaurant.reviewAmount)
            return "(\(count.formattedWithAbbreviations()) \(count > 1 ? "reviews" : "review"))"
        }
        return ""
    }
    
    //MARK: - Networking
    func fetchMoreComments(index: Int){
        if index == comments.count - 1{
            pageInfo.offset += Constants.DEFAULT_LIMIT
            print(pageInfo.offset)
            detailDataService.fetchComments(for: restaurant.id, offset: pageInfo.offset, limit: Constants.DEFAULT_LIMIT)
            print("More comments...")
        }
    }
    
    func refreshComments(){
        pageInfo.offset = 0
        comments.removeAll()
        detailDataService.fetchComments(for: restaurant.id, offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
    }
    
    private func fetchComments(){
        detailDataService.fetchComments(for: restaurant.id, offset: Constants.DEFAULT_OFFSET, limit: Constants.DEFAULT_LIMIT)
        detailDataService.$comments
            .sink { [weak self] fetchedComments in
                if let fetchedComments = fetchedComments{
                    self?.isLoading = false
                    self?.comments.append(contentsOf: fetchedComments)
                }
            }
            .store(in: &cancellables)
    }
}
