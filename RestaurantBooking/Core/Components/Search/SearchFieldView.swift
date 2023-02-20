//
//  SearchFieldView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import SwiftUI

struct SearchFieldView: View {
    @Binding var searchQuery: String
    var body: some View {
        HStack{
            Group{
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.theme.secondaryText)
                TextField("Search", text: $searchQuery)
                    .overlay(
                        Image(systemName: "xmark.circle.fill")
                            .padding()
                            .offset(x: 10)
                            .foregroundColor(Color.theme.green)
                            .opacity(searchQuery.isEmpty ? 0.0 : 1.0)
                            .onTapGesture {
                                searchQuery = ""
                            },
                        alignment: .trailing
                    )
            }
            Button{
                //do something
            }label: {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(Color.theme.green)
            }
        }
        .padding()
        .background(Color.theme.field)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct SearchFieldView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SearchFieldView(searchQuery: .constant(""))
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            SearchFieldView(searchQuery: .constant(""))
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
