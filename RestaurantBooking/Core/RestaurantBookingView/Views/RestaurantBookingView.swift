//
//  RestaurantBookingView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 12.03.2023.
//

import SwiftUI

struct RestaurantBookingView: View {
    @StateObject private var bookVM = BookViewModel()
    var body: some View {
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
    }
}

struct RestaurantBookingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            RestaurantBookingView()
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
        DatePicker("Select a Date", selection: $bookVM.book.date, in: bookVM.futureDateRange, displayedComponents: .date)
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
                        bookVM.selectedTimeInterval = bookVM.dateArray[index]
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
        TextEditor(text: $bookVM.book.specialWishes)
            .padding()
            .foregroundColor(Color.theme.secondaryText)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.theme.secondaryText.opacity(0.2), lineWidth: 3))
            .frame(height: 100)
            .padding(.horizontal)
    }
    
    private var footerView: some View{
        VStack{
            Text("Total ₸7,400")
                .font(.headline)
            PrimaryButton(buttonLabel: "Continue", buttonClicked: $bookVM.continueButtonTapped)
        }
        .padding(.horizontal)
        .padding(.top, 50)
    }
}
