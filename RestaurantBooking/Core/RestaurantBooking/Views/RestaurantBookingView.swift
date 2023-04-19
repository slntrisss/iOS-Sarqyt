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
                FoodView(title: bookVM.restaurantNameTitle, bookVM: bookVM, schemeVM: schemeVM)
            })
            orderFoodAlertView
            requiredFieldNotFilledAlertView
        }
        .onAppear{
            self.bookVM.setupBookingRestaurant()
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
        SchemeView(schemeVM: schemeVM)
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
            Text("\(bookVM.totalPriceForBooking.toKZTCurrency())")
                .font(.headline)
            PrimaryButton(buttonLabel: "Continue", buttonClicked: $bookVM.continueButtonTapped)
        }
        .onChange(of: bookVM.continueButtonTapped, perform: {_ in
                //TODO: Book restaurant
        })
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
                            bookVM.navigateToFoodView = true
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
                            bookVM.navigateToOrderView = true
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
    
    private var requiredFieldNotFilledAlertView: some View{
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
