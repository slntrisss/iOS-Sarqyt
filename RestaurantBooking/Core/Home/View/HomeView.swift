//
//  HomeView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 19.02.2023.
//

import SwiftUI

struct HomeView: View {
    @State private var searchQuery = ""
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
                SearchFieldView(searchQuery: $searchQuery)
            }
            .padding()
            .navigationTitle("Hello, Raim 👋")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {navLeadingItems}
                ToolbarItem(placement: .navigationBarTrailing) {navTrailingItems}
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


extension HomeView{
    
    private var navLeadingItems: some View{
        HStack{
            Image("logo")
                .resizable()
                .scaledToFit()
            Text("Sarqyt")
                .font(.title.bold())
        }
    }
    
    private var navTrailingItems: some View{
        HStack{
            Button{
                //do something
            }label: {
                Image(systemName: "bell")
            }
            
            Button{
                //do something
            }label: {
                Image(systemName: "bookmark")
            }
        }
    }
}
