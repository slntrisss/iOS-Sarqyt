//
//  RestaurantBookingView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 12.03.2023.
//

import SwiftUI

struct RestaurantBookingView: View {
    @ObservedObject var schemeVM: SchemeViewModel
    @ObservedObject var bookVM: BookViewModel
    init(bookVM: BookViewModel, schemeVM: SchemeViewModel) {
        self.bookVM = bookVM
        self.schemeVM = schemeVM
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
                    reserveTableView
                    specialWishLabel
                    specialWishesView
                    footerView
                }
            }
            .navigationTitle("Book")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $bookVM.navigateToOrderView, destination: {
                OrderView(orderedFoods: bookVM.wrappedOrderedFoods, bookedRestaurant: bookVM.wrappedBookedRestaurant)
            })
            .navigationDestination(isPresented: $bookVM.navigateToFoodView, destination: {
                FoodView(bookVM: bookVM, schemeVM: schemeVM)
            })
            .alert("", isPresented: $bookVM.showOrderFoodAlertView) {
                Button("OK"){
                    bookVM.navigateToFoodView = true
                }
                Button("Cancel"){
                    bookVM.showOrderFoodAlertView = false
                    bookVM.navigateToOrderView = true
                }
            } message: {
                Text("You have not ordered a food. Would you like to order a food?")
            }
            .alert("", isPresented: $bookVM.showRequiredFieldsMissedAlertView) {
                Button("Dismiss"){}
            } message: {
                Text("Please, choose an appropriate time for booking.")
            }
        }
        .onAppear{
            self.bookVM.setupBookingRestaurant(schemeVM: schemeVM)
        }
    }
}

struct RestaurantBookingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            RestaurantBookingView(bookVM: BookViewModel(restaurant: dev.restaurant), schemeVM: SchemeViewModel(restaurantId: dev.restaurant.id))
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
    
    private var reserveTableView: some View{
        SchemeView(schemeVM: schemeVM, restaurantId: bookVM.restaurant?.id ?? "", selectedDate: bookVM.selectedDate, numberOfGuests: $bookVM.numberOfGuests, selectedTimeInterval: $bookVM.selectedTime)
            .padding(.top, 20)
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
            Text("\(bookVM.reservcePrice.toKZTCurrency())")
                .font(.headline)
            PrimaryButton(buttonLabel: "Continue", buttonClicked: $bookVM.continueButtonTapped)
        }
        .padding(.horizontal)
        .padding(.top, 50)
    }
    
}
