//
//  RestaurantRatingStarView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 08.03.2023.
//

import SwiftUI

struct RestaurantRatingStarView: View {
    
    private var starRatings = Array<Double>(repeating: 0.0, count: 5)
    var gradient = LinearGradient(colors: [Color.yellow], startPoint: .leading, endPoint: .trailing)
    init(rating: Double){
        var temp = rating
        
        for i in 0...4{
            if temp >= 1.0{
                starRatings[i] = 1
                temp -= 1
            }else{
                starRatings[i] = temp
                break;
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 0){
            ForEach(0..<5, id: \.self){ index in
                Image(systemName: "star.fill")
                    .foregroundColor(.white)
                    .overlay(getGradient(at: index))
                    .mask(Image(systemName: "star.fill").renderingMode(.template))
                    .frame(width: 20, height: 20)
            }
        }
    }
    
    private func getGradient(at index: Int) -> some View{
        var colors: [Color] = []
        if starRatings[index] == 1.0{
            colors += [.yellow]
        }else if starRatings[index] == 0.0{
            colors += [Color.theme.secondaryText.opacity(0.3)]
        }else{
            colors += [.yellow, .white]
        }
        let gradient = LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
            .mask(Rectangle().frame(width: 100, height: 100))
        return gradient
    }
}

struct RestaurantRatingStarView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantRatingStarView(rating: 3.7)
    }
}
