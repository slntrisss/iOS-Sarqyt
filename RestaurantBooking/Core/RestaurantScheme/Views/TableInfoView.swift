//
//  TableInfoView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 16.04.2023.
//

import SwiftUI

struct TableInfoView: View {
    @ObservedObject var schemeVM: SchemeViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTime: String
    @Binding var numberOfGuests: Int
    init(schemeVM: SchemeViewModel, selectedTime: Binding<String>,
         numberOfGuests: Binding<Int>) {
        self.schemeVM = schemeVM
        self._selectedTime = selectedTime
        self._numberOfGuests = numberOfGuests
    }
    var body: some View {
        if let tableInfo = schemeVM.tableInfo{
            ScrollView{
                LazyVStack(spacing: 20){
                    Spacer().frame(height: 20)
                    Text("Table #\(schemeVM.selectedIndex + 1)")
                        .font(.title2.weight(.semibold))
                    images(tableInfo)
                    horizontalInfoView(tableInfo)
                    descriptionView(tableInfo)
                    timePickerLabel
                    timePickerView
                    numberOfGuestsLabel
                    numberOfGuestsView
                }
            }
            .onAppear{
                schemeVM.selectedTime = selectedTime
                schemeVM.numberOfGuests = numberOfGuests
            }
            .safeAreaInset(edge: .bottom) {
                addButton
            }
        }
    }
}

struct TableInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            TableInfoView(schemeVM: SchemeViewModel(restaurantId: dev.restaurant.id), selectedTime: .constant(""), numberOfGuests: .constant(1))
        }
    }
}

extension TableInfoView{
    private func images(_ tableInfo: TableInfo) -> some View{
        TabView{
            ForEach(0..<tableInfo.images.count, id: \.self){ index in
                Image(uiImage: tableInfo.wrappedImage(for: tableInfo.images[index]))
                    .resizable()
                    .scaledToFill()
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(width: 300)
        .frame(height: 200)
        .shadow(radius: 15)
    }
    
    private func horizontalInfoView(_ tableInfo: TableInfo) -> some View{
        HStack{
            VStack{
                Text("Floor")
                    .font(.headline)
                    .foregroundColor(Color.theme.secondaryText)
                Text("\(tableInfo.floor)")
                    .font(.headline)
            }
            Spacer()
            VStack{
                Text("Chairs")
                    .font(.headline)
                    .foregroundColor(Color.theme.secondaryText)
                Text("\(tableInfo.numberOfChairs)")
                    .font(.headline)
            }
            Spacer()
            VStack{
                Text("Price")
                    .font(.headline)
                    .foregroundColor(Color.theme.secondaryText)
                Text("\(tableInfo.reservePrice.toKZTCurrency())")
                    .font(.headline)
            }
        }
        .padding(.horizontal)
    }
    
    private func descriptionView(_ tableInfo: TableInfo) -> some View{
        ScrollView{
            Text(tableInfo.description)
                .font(.callout)
                .foregroundColor(Color.theme.secondaryText)
                .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(height: UIScreen.main.bounds.height * 0.2)
        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.theme.secondaryText.opacity(0.5), lineWidth: 2))
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
    private var timePickerLabel: some View{
        HStack{
            Image(systemName: "timer")
            Text("Available at:")
            Spacer()
        }
        .font(.headline)
        .padding(.horizontal)
    }
    
    private var timePickerView: some View{
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack {
                if let tableInfo = schemeVM.tableInfo{
                    ForEach(tableInfo.availableTimeInterval.indices, id: \.self) { index in
                        Button{
                            schemeVM.setSelectedTimeInterval(index: index)
                            selectedTime = tableInfo.availableTimeInterval[index]
                        }label: {
                            Text(tableInfo.availableTimeInterval[index])
                                .font(.subheadline.weight(.medium))
                                .padding()
                                .background(schemeVM.isSelectedTimeInterval(index: index) ? Color.theme.green.opacity(0.6) : Color.theme.secondaryButton)
                                .foregroundColor(schemeVM.isSelectedTimeInterval(index: index) ? Color.white : Color.theme.accent)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.leading, index == 0 ? 20 : 0)
                                .padding(.trailing, index == tableInfo.availableTimeInterval.count - 1 ? 20 : 4)
                                .shadow(radius: 3)
                        }
                    }
                }
            }
            .padding(.top, 5)
            .padding(.bottom, 20)
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
                schemeVM.decreaseNumberOfGuests()
            }label: {
                Image(systemName: "minus.square")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.theme.secondaryText)
            }
            Spacer()
            HStack{
                Text(schemeVM.numberOfGuestsLabel)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color.theme.secondaryText)
            }
            Spacer()
            Button{
                schemeVM.increaseNumberOfGuests()
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
        .onChange(of: schemeVM.numberOfGuests) { _ in
            numberOfGuests = schemeVM.numberOfGuests
        }
    }
    
    private var addButton: some View{
        ZStack{
            PrimaryButton(buttonLabel: "Save changes", buttonClicked: $schemeVM.saveChanges)
                .onChange(of: schemeVM.saveChanges) { _ in
                    if schemeVM.saveChanges{
                        dismiss()
                    }
                }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}
