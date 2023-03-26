//
//  RestaurantBookingView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 12.03.2023.
//

import SwiftUI

struct RestaurantBookingView: View {
    @ObservedObject var bookVM: BookViewModel
    init(bookVM: BookViewModel) {
        self.bookVM = bookVM
    }
    var body: some View {
        ZStack{
            ScrollView(.vertical){
                LazyVStack {
                    Group{
                        dateAndTimeLabel
                        datePickerView
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    timePickerView
                    numberOfGuestsLabel
                    numberOfGuestsView
                    specialWishLabel
                    specialWishesView
                    footerView
                }
            }
            .navigationTitle("Book")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{self.bookVM.setupBookingRestaurant()}
            orderFoodAlertView
            requiredFiledNotFilledAlertView
        }
    }
}

struct RestaurantBookingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            RestaurantBookingView(bookVM: BookViewModel())
        }
    }
}

extension RestaurantBookingView{
    
    private var dateAndTimeLabel: some View{
        HStack{
            Image(systemName: "calendar.badge.clock")
            Text("Date & Time")
                .font(.headline)
            Spacer()
        }
    }
    
    private var datePickerView: some View{
        DatePicker("Select a Date", selection: $bookVM.selectedDate, in: bookVM.allowedDatesToChoose, displayedComponents: .date)
            .tint(Color.theme.green)
            .foregroundColor(Color.theme.green)
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            .background(Color.theme.secondaryButton)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
    }
    
    private var timePickerView: some View{
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack {
                ForEach(0..<bookVM.dateArray.count, id: \.self) { index in
                    Button{
                        bookVM.setSelectedTimeInterval(index: index)
                    }label: {
                        Text(bookVM.dateArray[index].formatted(date: .omitted, time: .shortened))
                            .font(.subheadline.weight(.medium))
                            .padding()
                            .background(bookVM.isSelectedTimeInterval(index: index) ? Color.theme.green.opacity(0.6) : Color.theme.secondaryButton)
                            .foregroundColor(bookVM.isSelectedTimeInterval(index: index) ? Color.white : Color.theme.accent)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.leading, index == 0 ? 20 : 0)
                            .padding(.trailing, index == bookVM.dateArray.count - 1 ? 20 : 4)
                            .shadow(radius: 3)
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    private var numberOfGuestsLabel: some View{
        HStack{
            Image(systemName: "person.2")
            Text("Guest")
            Spacer()
        }
        .font(.headline)
        .padding(.horizontal)
    }
    
    private var numberOfGuestsView: some View{
        HStack{
            Button{
                bookVM.decreaseNumberOfGuests()
            }label: {
                Image(systemName: "minus.square")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.theme.secondaryText)
            }
            Spacer()
            HStack{
                Text(bookVM.getGuestsLabel())
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color.theme.secondaryText)
            }
            Spacer()
            Button{
                bookVM.increaseNumberOfGuests()
            }label: {
                Image(systemName: "plus.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.theme.green)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.theme.secondaryButton)
        .padding(.horizontal)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 3)
    }
    
    private var specialWishLabel: some View{
        HStack{
            Image(systemName: "sparkles")
            Text("Special Wishes")
                .font(.headline)
            Spacer()
        }
        .padding()
    }
    
    private var specialWishesView: some View{
        TextEditor(text: $bookVM.specialWishes)
            .padding()
            .foregroundColor(Color.theme.secondaryText)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.theme.secondaryText.opacity(0.2), lineWidth: 3))
            .frame(height: 100)
            .padding(.horizontal)
    }
    
    private var footerView: some View{
        VStack{
            Text("\(bookVM.totalPriceForBooking.toKZTCurrency())")
                .font(.headline)
            PrimaryButton(buttonLabel: "Continue", buttonClicked: $bookVM.continueButtonTapped)
        }
        .onChange(of: bookVM.continueButtonTapped, perform: {_ in bookVM.bookButtonTapped()})
        .padding(.horizontal)
        .padding(.top, 50)
    }
    
    private var orderFoodAlertView: some View{
        AlertBuilder(showAlert: $bookVM.showOrderFoodAlertView) {
            VStack{
                Text("You have not ordered a food. Would you like to order a food?")
                    .multilineTextAlignment(.center)
                    .font(.callout.weight(.medium))
                    .padding(.vertical)
                HStack{
                    Button{
                        withAnimation {
                            
                        }
                    }label: {
                        Text("OK")
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.theme.green)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    Button{
                        withAnimation {
                            bookVM.showOrderFoodAlertView = false
                        }
                    }label: {
                        Text("Cancel")
                            .foregroundColor(Color.theme.accent)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.theme.secondaryButton)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .frame(width: 250)
        }
    }
    
    private var requiredFiledNotFilledAlertView: some View{
        AlertBuilder(showAlert: $bookVM.showRequiredFieldsMissedAlertView) {
            VStack{
                Text("Please, choose an appropriate time for booking.")
                    .multilineTextAlignment(.center)
                    .font(.callout.weight(.medium))
                    .padding(.vertical)
                Button{
                    withAnimation {
                        bookVM.showRequiredFieldsMissedAlertView = false
                    }
                }label: {
                    Text("Dismiss")
                        .foregroundColor(Color.theme.accent)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.theme.secondaryButton)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .frame(width: 250)
        }
    }
}
