//
//  BookingView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import SwiftUI

struct BookingView: View {
    @StateObject private var bookingVM = BookingViewModel()
    @State private var currentTab = 0
    var body: some View {
        ZStack{
            NavigationStack{
                VStack{
                    TabBarView(currentTab: $currentTab)
                        .padding(.vertical)
                    
                    TabView(selection: $currentTab){
                        BookingListView(bookingVM: bookingVM, bookingList: bookingVM.isOngoingRestaurantsLoading ? $bookingVM.ongoingRestaurantsPlacholder : $bookingVM.ongoingBookings, status: .ongoing)
                            .environmentObject(bookingVM)
                            .tag(0)
                            .redacted(reason: bookingVM.isOngoingRestaurantsLoading ? .placeholder : [])
                            .shimmering(active: bookingVM.isOngoingRestaurantsLoading)
                        BookingListView(bookingVM: bookingVM, bookingList: bookingVM.isCompletedRestaurantsLoading ? $bookingVM.completedRestaurantsPlacholder : $bookingVM.completedBookings, status: .completed)
                            .environmentObject(bookingVM)
                            .tag(1)
                            .redacted(reason: bookingVM.isCompletedRestaurantsLoading ? .placeholder : [])
                            .shimmering(active: bookingVM.isCompletedRestaurantsLoading)
                        BookingListView(bookingVM: bookingVM, bookingList: bookingVM.isCancelledRestaurantsLoading ? $bookingVM.cancelledRestaurantsPlacholder : $bookingVM.cancelledBookings, status: .cancelled)
                            .environmentObject(bookingVM)
                            .tag(2)
                            .redacted(reason: bookingVM.isCancelledRestaurantsLoading ? .placeholder : [])
                            .shimmering(active: bookingVM.isCancelledRestaurantsLoading)
                    }
                    .padding()
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .toolbar{ToolbarItem(placement: .navigation) {navBar}}
                }
            }
            if bookingVM.showProgressView{
                Color.black.opacity(0.55).edgesIgnoringSafeArea(.all)
                ConfirmLoadingView(showCheckmark: $bookingVM.showCheckmark)
            }
        }
        .onAppear{
            bookingVM.addSubscriptions()
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
