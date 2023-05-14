//
//  BookingListView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 25.02.2023.
//

import SwiftUI

struct BookingListView: View {
    @ObservedObject var bookingVM: BookingViewModel
    @Binding var bookingList: [Restaurant]
    let status: BookingStatus
    init(bookingVM: BookingViewModel, bookingList: Binding<[Restaurant]>, status: BookingStatus) {
        self._bookingVM = ObservedObject(wrappedValue: bookingVM)
        self._bookingList = bookingList
        self.status = status
    }
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            ZStack(alignment: .center){
                LazyVStack{
                    ForEach(bookingList.indices, id: \.self) { index in
                        BookingCardView(restaurant: bookingList[index])
                            .environmentObject(bookingVM)
                            .padding(.bottom, 40)
                            .onAppear{
                                bookingVM.requestMoreItems(for: status, index: index)
                            }
                    }
                }
                .opacity(bookingVM.showEmptyPlaceholder(status: status) ? 0.0 : 1.0)
                EmptyResultView(title: "No results found")
                    .frame(height: UIScreen.main.bounds.height * 0.5)
                    .opacity(bookingVM.showEmptyPlaceholder(status: status) ? 1.0 : 0.0)
            }
        }
        .onAppear{
            bookingVM.fetchInitialData(for: status)
        }
        .refreshable {
            bookingVM.refreshItems(for: status)
        }
    }
}

struct BookingListView_Previews: PreviewProvider {
    static var previews: some View {
        BookingListView(bookingVM: BookingViewModel(), bookingList: .constant([]), status: .ongoing)
    }
}
