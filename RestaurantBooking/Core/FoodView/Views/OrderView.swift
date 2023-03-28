//
//  OrderedFoodsView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 23.03.2023.
//

import SwiftUI

struct OrderView: View {
    @StateObject private var orderVM: OrderViewModel
    let restaurant: Restaurant
    init(orderedFoods: [OrderedFood], restaurant: Restaurant, bookingRestaurant: BookingRestaurant){
        self.restaurant = restaurant
        self._orderVM = StateObject(wrappedValue: OrderViewModel(orderedFoods: orderedFoods, bookingRestaurant: bookingRestaurant))
    }
    var body: some View {
        ScrollView{
            LazyVStack(alignment: .leading){
                restaurantBookingTitle
                VStack(spacing: 25){
                    orderedRestaurantCardView
                    numberOfGuestsView
                    bookingTimeView
                    changeRestaurantBookingButton
                }
                .padding(.horizontal)
                Spacer()
                    .frame(height: 30)
                foodTitleView
                ForEach(orderVM.orderedFoods) { orderedFood in
                    constructOrderedFoodView(orderedFood: orderedFood)
                    Divider()
                }
                .padding(.horizontal)
                Spacer()
                    .frame(height: 30)
                paymentMethodView
                Spacer()
                    .frame(height: 30)
            }
            summaryView
        }
        .customConfirmDialog(isPresented: $orderVM.showAllPaymentsMethodLists, actions: {
            allPaymentMethodsList
        })
        .navigationTitle("Order")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {cancelBookingButton}
        }
    }
}

struct OrderedFoodsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            OrderView(orderedFoods: dev.orderedFoods, restaurant: dev.restaurant, bookingRestaurant: dev.bookingRestaurant)
        }
    }
}

extension OrderView{
    private var cancelBookingButton: some View{
        Button{
            
        }label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
    //MARK: - Food
    private var foodTitleView: some View{
        Text("Food")
            .font(.title2.weight(.bold))
            .foregroundColor(Color.theme.accent)
            .padding(.horizontal)
    }
    private func constructOrderedFoodView(orderedFood: OrderedFood) -> some View{
        HStack{
            Image(orderedFood.food.image)
                .resizable()
                .scaledToFit()
                .frame(width: 80)
            VStack(alignment: .leading, spacing: 5){
                Text(orderedFood.food.name)
                    .font(.subheadline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                Text(orderedFood.price.toKZTCurrency())
                    .font(.caption.weight(.semibold))
                HStack(spacing: 20){
                    Button{
                        
                    }label: {
                        Image(systemName: "minus")
                            .foregroundColor(Color.theme.accent)
                    }
                    Text("\(orderedFood.count)")
                    Button{
                        
                    }label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color.theme.accent)
                            .contentShape(Rectangle())
                    }
                }
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.theme.secondaryText.opacity(0.2)))
            }
        }
    }
    //MARK: - Restaurant View
    private var restaurantBookingTitle: some View{
        Text("Restaurant")
            .font(.title2.weight(.bold))
            .foregroundColor(Color.theme.accent)
            .padding(.horizontal)
    }
    private var orderedRestaurantCardView: some View{
        HStack{
            cardImage
            VStack(alignment: .leading, spacing: 10){
                Text(restaurant.name)
                    .font(.headline.bold())
                    .foregroundColor(Color.theme.accent)
                    .lineLimit(1)
                Text(restaurant.address.city)
                    .font(.subheadline)
                    .foregroundColor(Color.theme.secondaryText)
                ratingView
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.theme.field))
    }
    private var ratingView: some View{
        HStack(spacing: 2){
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Text(restaurant.rating.asNumberStringWithOneDigit())
                .font(.subheadline.bold())
                .foregroundColor(Color.theme.green)
        }
    }
    private var cardImage: some View{
        Image(restaurant.image)
            .resizable()
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    private var numberOfGuestsView: some View{
        HStack{
            Text("Number of guests")
                .font(.callout.weight(.semibold))
                .foregroundColor(Color.theme.accent.opacity(0.8))
            Spacer()
            HStack(spacing: 20){
                Button{
                    
                }label: {
                    Image(systemName: "minus")
                        .foregroundColor(Color.theme.accent)
                }
                Text("1")
                Button{
                    
                }label: {
                    Image(systemName: "plus")
                        .foregroundColor(Color.theme.accent)
                        .contentShape(Rectangle())
                }
            }
            .padding(5)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.theme.secondaryText.opacity(0.2)))
        }
    }
    
    private var bookingTimeView: some View{
        HStack{
            Text("Booked Time")
                .font(.callout.weight(.semibold))
                .foregroundColor(Color.theme.accent.opacity(0.8))
            Spacer()
            VStack{
                Text(Date().formatted(date: .abbreviated, time: .shortened))
                    .font(.callout.weight(.semibold))
                    .foregroundColor(Color.theme.accent.opacity(0.8))
            }
        }
    }
    
    private var changeRestaurantBookingButton: some View{
        HStack{
            Spacer()
            Button{
                
            }label: {
                Text("Change")
                    .padding(.vertical, 7)
                    .padding(.horizontal, 12)
                    .foregroundColor(.white)
                    .font(.headline)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.theme.green))
            }
        }
    }
    //MARK: - Payment
    private var paymentMethodView: some View{
        VStack(alignment: .leading){
            Text("Payment method")
                .font(.title2.weight(.bold))
                .foregroundColor(Color.theme.accent)
            
            HStack{
                Image(systemName: "creditcard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .foregroundColor(Color.theme.accent.opacity(0.8))
                Text("Add payment method")
                    .font(.headline)
                    .foregroundColor(Color.theme.accent.opacity(0.8))
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .padding(.horizontal)
        .onTapGesture {
            orderVM.showAllPaymentsMethodLists.toggle()
        }
    }
    
    private var allPaymentMethodsList: some View{
        VStack{
            Button {
                
            } label: {
                Label("Add payment method", systemImage: "note.text.badge.plus")
            }
        }
    }
    //MARK: - Summary
    private var summaryView: some View{
        VStack{
            VStack(spacing: 10){
                HStack{
                    Text("Summary")
                        .font(.title2.weight(.bold))
                        .foregroundColor(Color.theme.accent)
                    Spacer()
                }
                
                HStack{
                    Text("Restaurant")
                    Spacer()
                    Text(14745.0.toKZTCurrency())
                }
                
                HStack{
                    Text("Food")
                    Spacer()
                    Text(14745.0.toKZTCurrency())
                }
                
                HStack{
                    Text("Service")
                    Spacer()
                    Text(14745.0.toKZTCurrency())
                }
                
                HStack{
                    Text("Total")
                        .font(.title2.weight(.semibold))
                    Spacer()
                    Text(14745.0.toKZTCurrency())
                }
                .padding(.vertical)
                .font(.title3.weight(.semibold))
            }
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .padding([.horizontal, .vertical])
        }
        .background(Color.theme.secondaryButton)
    }
}
