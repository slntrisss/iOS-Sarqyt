//
//  BookingListView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 25.02.2023.
//

import SwiftUI

struct BookingListView: View {
    let label: String
    var body: some View {
        Text(label)
    }
}

struct BookingListView_Previews: PreviewProvider {
    static var previews: some View {
        BookingListView(label: "Completed")
    }
}
