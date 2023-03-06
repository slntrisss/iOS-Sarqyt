//
//  BookingCardView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 02.03.2023.
//

import SwiftUI

struct BookingCardView: View {
    let restaurant: Restaurant
    
    @State private var cancelBookingTapped = false
    @State private var viewTicketTapped = false
    
    @State private var dismissCancelBookingDialogTapped = false
    @State private var cancelBooking = false
    var body: some View {
        VStack(alignment: .leading){
            HStack(spacing: 15){
                Image(restaurant.image)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                VStack(alignment: .leading, spacing: 10){
                    Text(restaurant.name)
                        .foregroundColor(Color.theme.accent)
                        .font(.title3.bold())
                    Text("\(restaurant.address.city), \(restaurant.address.location)")
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
            
            if restaurant.bookingStatus == .ongoing{
                Divider()
                    .padding(.vertical, 5)
                ongoingActionButtons
                    .onChange(of: dismissCancelBookingDialogTapped, perform: {_ in cancelBookingTapped.toggle()})
            }
        }
        .sheet(isPresented: $cancelBookingTapped, content: {
            CancelBookingView(dismissButtonTapped: $dismissCancelBookingDialogTapped,
                              cancelButtonTapped: $cancelBooking)})
    }
}

struct BookingCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookingCardView(restaurant: dev.restaurant)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
                .padding()
            
            BookingCardView(restaurant: dev.restaurant)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .padding()
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
