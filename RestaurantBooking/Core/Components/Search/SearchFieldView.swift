//
//  SearchFieldView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import SwiftUI

struct SearchFieldView: View {
    @Binding var searchQuery: String
    @Binding var searchFieldInFocus: Bool
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.theme.secondaryText)
            
            searchTextField
            
            filterButton
            
            if searchFieldInFocus{
                cancelButton
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
            SearchFieldView(searchQuery: .constant(""), searchFieldInFocus: .constant(true))
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            SearchFieldView(searchQuery: .constant(""), searchFieldInFocus: .constant(true))
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension SearchFieldView{
    
    private var cancelButton: some View{
        Button{
            withAnimation {
                searchFieldInFocus = false
            }
            searchQuery = ""
            UIApplication.shared.endEditing()
        }label: {
            Text("Cancel")
                .font(.caption)
                .foregroundColor(Color.theme.green)
        }
    }
    
    private var filterButton: some View{
        Button{
            //do something
        }label: {
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(Color.theme.green)
        }
    }
    
    private var searchTextField: some View{
        TextField("Search", text: $searchQuery)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.5)) {
                    searchFieldInFocus = true
                }
            }
    }
}
