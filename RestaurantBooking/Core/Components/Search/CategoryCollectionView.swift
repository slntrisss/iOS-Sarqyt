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
    let leadingSpacing: CGFloat
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                ForEach(collections.indices, id: \.self) { index in
                    Button{
                        selectedCollection = collections[index]
                    }label: {
                        Text(collections[index])
                            .font(.title3)
                            .foregroundColor(selectedCollection == collections[index] ? Color.white : Color.theme.green)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(selectedCollection == collections[index] ? Color.theme.green : Color.theme.collectionBackground)
                            )
                            .overlay(
                                Capsule()
                                    .strokeBorder(Color.theme.green, lineWidth: 2)
                            )
                            .clipShape(Capsule())
                            .offset(x: leadingSpacing)
                            .padding(.trailing, index == endIndex ? leadingSpacing * 2 : 0)
                    }
                }
            }
        }
    }
}

struct CategoryCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            CategoryCollectionView(collections: dev.collections, selectedCollection: .constant("Recommended"), leadingSpacing: 20)
                .padding(.vertical)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            CategoryCollectionView(collections: dev.collections, selectedCollection: .constant("Recommended"), leadingSpacing: 20)
                .padding(.vertical)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension CategoryCollectionView{
    private var endIndex: Int{
        return collections.count - 1
    }
}
