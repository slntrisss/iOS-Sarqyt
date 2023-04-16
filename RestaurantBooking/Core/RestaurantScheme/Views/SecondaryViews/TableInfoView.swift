//
//  TableInfoView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 16.04.2023.
//

import SwiftUI

struct TableInfoView: View {
    @ObservedObject var schemeVM: SchemeViewModel
    init(schemeVM: SchemeViewModel) {
        self.schemeVM = schemeVM
    }
    var body: some View {
        if let tableInfo = schemeVM.tableInfo{
            VStack(spacing: 20){
                Spacer().frame(height: 20)
                Text("Table #\(schemeVM.selectedIndex + 1)")
                    .font(.title2.weight(.semibold))
                images(tableInfo)
                horizontalInfoView(tableInfo)
                descriptionView(tableInfo)
            }
        }
    }
}

struct TableInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            TableInfoView(schemeVM: SchemeViewModel())
        }
    }
}

extension TableInfoView{
    private func images(_ tableInfo: TableInfo) -> some View{
        TabView{
            ForEach(0..<tableInfo.images.count, id: \.self){ index in
                Image(tableInfo.images[index])
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
}
