//
//  BookingView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import SwiftUI

struct BookingView: View {
    @State private var currentTab = 1
    var body: some View {
        NavigationStack{
            ZStack(alignment: .top){
                
                TabView(selection: $currentTab){
                    BookingListView(label: "Ongoing")
                        .tag(0)
                    BookingListView(label: "Completed")
                        .tag(1)
                    BookingListView(label: "Cancelled")
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .toolbar{ToolbarItem(placement: .navigation) {navBar}}
                
                TabBarView(currentTab: $currentTab)
                    .padding(.vertical)
            }
        }
    }
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        BookingView()
    }
}

extension BookingView{
    private var navBar: some View{
        HStack{
            Image("logo")
                .resizable()
                .scaledToFit()
            Text("My Booking")
                .font(.title.bold())
                .foregroundColor(Color.theme.accent)
            
        }
    }
}
