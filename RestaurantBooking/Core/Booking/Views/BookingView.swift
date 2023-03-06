//
//  BookingView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import SwiftUI

struct BookingView: View {
    @StateObject private var bookingVM = BookingViewModel()
    @State private var currentTab = 1
    var body: some View {
        NavigationStack{
            VStack{
                TabBarView(currentTab: $currentTab)
                    .padding(.vertical)
                
                TabView(selection: $currentTab){
                    BookingListView(bookingList: $bookingVM.ongoingBookings)
                        .environmentObject(bookingVM)
                        .tag(0)
                    BookingListView(bookingList: $bookingVM.completedBookings)
                        .environmentObject(bookingVM)
                        .tag(1)
                    BookingListView(bookingList: $bookingVM.cancelledBookings)
                        .environmentObject(bookingVM)
                        .tag(2)
                }
                .padding()
                .tabViewStyle(.page(indexDisplayMode: .never))
                .toolbar{ToolbarItem(placement: .navigation) {navBar}}
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
