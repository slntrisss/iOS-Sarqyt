//
//  FoodView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.03.2023.
//

import SwiftUI

struct FoodView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var foodVM = FoodViewModel()
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 10),
        GridItem(.adaptive(minimum: 150), spacing: 10),
    ]
    let title: String
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]){
                contentView
            }
        }
        .overlay(titleBackground, alignment: .top)
        .navigationBarBackButtonHidden(true)
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView(title: "Restaurant")
    }
}

extension FoodView{
    private var tabBarView: some View{
        ScrollViewReader { scrollView in
            navBar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0){
                    ForEach(foodVM.tabBars.indices, id: \.self){ index in
                        VStack{
                            Text(foodVM.tabBars[index])
                                .font(foodVM.getSelectedTabBarFont(at: index))
                                .padding(.horizontal)
                                .onTapGesture {foodVM.selectTabBar(at: index, scrollView: scrollView)}
                            Capsule()
                                .frame(height: 3)
                                .foregroundColor(foodVM.getSelectedTabBarColor(at: index))
                        }
                    }
                }
            }
        }
        .background(Color.theme.background)
    }
    
    private var contentView: some View{
        Section(header: tabBarView) {
            LazyVGrid(columns: columns) {
                ForEach(foodVM.foods) { food in
                    FoodCardView(food: food, foodVM: foodVM)
                        .padding(10)
                }
            }
            .padding()
        }
    }
    
    private var titleBackground: some View{
        Color.theme.background
            .frame(height: foodVM.topSafeAreaInset)
            .ignoresSafeArea(.all, edges: .top)
    }
    private var navBar: some View{
        HStack{
            Group{
                HStack{
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "arrow.left")
                            .padding(.horizontal)
                    }
                    Spacer()
                }
                Text(title)
                    .font(.headline)
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.33)
        }
    }
}
