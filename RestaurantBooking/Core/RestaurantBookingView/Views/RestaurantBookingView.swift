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
        ScrollView(.vertical, showsIndicators: false){
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
            numberOfGuestsLabel
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
}
