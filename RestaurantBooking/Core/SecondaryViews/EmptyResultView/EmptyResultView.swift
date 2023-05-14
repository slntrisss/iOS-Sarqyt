//
//  EmptyResultView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 14.05.2023.
//

import SwiftUI

struct EmptyResultView: View {
    let title: String
    let description: String?
    
    init(title: String, description: String? = nil) {
        self.title = title
        self.description = description
    }
    var body: some View {
        VStack(spacing: 30){
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.width * 0.2)
                .foregroundColor(Color.theme.secondaryText)
            VStack(spacing: 5){
                Text(title)
                    .foregroundColor(Color.theme.accent)
                    .font(.title)
                    .fontWeight(.semibold)
                Text(description ?? "")
                    .foregroundColor(Color.theme.secondaryText)
                    .font(.subheadline)
            }
        }
    }
}

struct EmptyResultView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyResultView(title: "No results found", description: "Check the spelling or try a new search")
    }
}
