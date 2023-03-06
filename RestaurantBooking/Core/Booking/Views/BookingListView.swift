//
//  BookingListView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 25.02.2023.
//

import SwiftUI

struct BookingListView: View {
    @EnvironmentObject var bookingVM: BookingViewModel
    @Binding var bookingList: [Restaurant]
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            ForEach(bookingList) { list in
                BookingCardView(restaurant: list)
                    .padding(.bottom, 40)
            }
        }
    }
}

struct BookingListView_Previews: PreviewProvider {
    static var previews: some View {
        BookingListView(bookingList: .constant([]))
    }
}
