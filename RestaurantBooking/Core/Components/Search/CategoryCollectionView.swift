//
//  CategoryCollectionView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import SwiftUI

struct CategoryCollectionView<T: StringProtocol>: View {
    let collections: [T]
    @Binding var selectedCollection: T
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                ForEach(collections, id: \.self) { collection in
                    Button{
                        selectedCollection = collection
                    }label: {
                        Text(collection)
                            .font(.title3)
                            .foregroundColor(selectedCollection == collection ? Color.white : Color.theme.green)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(selectedCollection == collection ? Color.theme.green : Color.theme.collectionBackground)
                            )
                            .overlay(
                                Capsule()
                                    .strokeBorder(Color.theme.green, lineWidth: 2)
                            )
                    }
                }
            }
        }
    }
}

struct CategoryCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            CategoryCollectionView(collections: dev.collections, selectedCollection: .constant("Recommended"))
                .padding(.leading)
                .padding(.vertical)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            CategoryCollectionView(collections: dev.collections, selectedCollection: .constant("Recommended"))
                .padding(.leading)
                .padding(.vertical)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
