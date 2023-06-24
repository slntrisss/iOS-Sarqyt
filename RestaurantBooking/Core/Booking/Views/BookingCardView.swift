//
//  BookingCardView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 02.03.2023.
//

import SwiftUI

struct BookingCardView: View {
    let restaurant: ReservedRestaurant
    @EnvironmentObject private var bookingVM : BookingViewModel
    @StateObject private var passcodeVM = PasscodeViewModel(type: .verifyIdentity)
    @State private var cancelBookingTapped = false
    @State private var viewTicketTapped = false
    
    @State private var dismissCancelBookingDialogTapped = false
    @State private var cancelBooking = false
    
    var body: some View {
        VStack(alignment: .leading){
            HStack(spacing: 15){
                Image(uiImage: restaurant.wrappedImage)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                VStack(alignment: .leading, spacing: 10){
                    Text(restaurant.name)
                        .foregroundColor(Color.theme.accent)
                        .font(.title3.bold())
                    Text("\(restaurant.address.city), \(restaurant.address.address)")
                        .foregroundColor(Color.theme.secondaryText)
                        .font(.caption)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                    
                    Text(restaurant.bookingStatus.rawValue)
                        .font(.caption.bold())
                        .foregroundColor(restaurant.bookingStatus == .cancelled ? .red : Color.theme.green)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
                        .background(restaurant.bookingStatus == .cancelled ? Color.theme.redStatus : Color.theme.greenStatus)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                Spacer()
            }
            
            if restaurant.bookingStatus == .ongoing && !bookingVM.isOngoingRestaurantsLoading{
                Divider()
                    .padding(.vertical, 5)
                ongoingActionButtons
                    .onChange(of: dismissCancelBookingDialogTapped, perform: {_ in cancelBookingTapped.toggle()})
                    .onChange(of: viewTicketTapped) { _ in
                        bookingVM.viewTicketButtonTapped(restaurantId: restaurant.id)
                    }
            }
        }
//        .sheet(isPresented: $cancelBookingTapped, content: {
//            CancelBookingView(dismissButtonTapped: $dismissCancelBookingDialogTapped,
//                              cancelButtonTapped: $cancelBooking)
//            .onChange(of: cancelBooking) { _ in
//                if cancelBooking{
//                    cancelBooking.toggle()
//                    cancelBookingTapped.toggle()
//                    bookingVM.addPasscodeSubscription(passcodeVM: passcodeVM, for: restaurant)
//                }
//            }
//        })
        .sheet(isPresented: $viewTicketTapped) {
            NavigationStack{
                ReserveInfoView(bookingVM: bookingVM, restaurantId: restaurant.id, orderItemId: restaurant.orderItemId)
            }
        }
        .onChange(of: cancelBookingTapped, perform: { newValue in
            bookingVM.addPasscodeSubscription(passcodeVM: passcodeVM, for: restaurant)
        })
        .fullScreenCover(isPresented: $cancelBookingTapped) {
            NumberPadView(passcodeVM: passcodeVM)
        }
    }
}

extension BookingCardView{
    
    private var ongoingActionButtons: some View{
        HStack{
            SecondaryButton(buttonLabel: "Cancel Booking", buttonClicked: $cancelBookingTapped)
            PrimaryButton(buttonLabel: "View Ticket", buttonClicked: $viewTicketTapped)
        }
    }
}
