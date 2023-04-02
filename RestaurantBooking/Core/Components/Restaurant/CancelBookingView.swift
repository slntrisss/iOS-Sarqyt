//
//  CancelBookingView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 05.03.2023.
//

import SwiftUI

struct CancelBookingView: View {
    @Binding var dismissButtonTapped: Bool
    @Binding var cancelButtonTapped: Bool
    var body: some View {
        VStack(spacing: 20){
            Capsule()
                .fill(Color.theme.secondaryText.opacity(0.5))
                .frame(width: 40, height: 5)
            Text("Cancel Booking")
                .font(.title.weight(.semibold))
                .foregroundColor(.red)
            
            Divider()
            
            Text("Are you sure you want to cancel your booking?")
                .font(.title3.weight(.medium))
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.5)
            
            Text("Only 80% of the money ypu can refund from your paymentaccording to our policy")
                .font(.subheadline)
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.5)
            
            HStack{
                SecondaryButton(buttonLabel: "Cancel", buttonClicked: $dismissButtonTapped)
                PrimaryButton(buttonLabel: "Yes, Continue", buttonClicked: $cancelButtonTapped)
            }
        }
        .padding()
        .presentationDetents([.height(300)])
    }
}

struct CancelBookingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CancelBookingView(dismissButtonTapped: .constant(false), cancelButtonTapped: .constant(false))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            CancelBookingView(dismissButtonTapped: .constant(false), cancelButtonTapped: .constant(false))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
