//
//  FoodView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.03.2023.
//

import SwiftUI

struct FoodView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var bookVM: BookViewModel
    @ObservedObject private var schemeVM: SchemeViewModel
    @StateObject private var foodVM: FoodViewModel
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 10),
        GridItem(.adaptive(minimum: 150), spacing: 10),
    ]
    
    let title: String
    
    init(bookVM: BookViewModel, schemeVM: SchemeViewModel){
        self.title = "Food & Dishes"
        self.bookVM = bookVM
        self.schemeVM = schemeVM
        self._foodVM = StateObject(wrappedValue: FoodViewModel(bookVM: bookVM))
    }
    
    var body: some View {
        ZStack{
            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]){
                    contentView
                }
            }
            .refreshable {
                foodVM.refreshFoods()
            }
            .onChange(of: bookVM.orderedFoods, perform: { _ in foodVM.displayOrderButton()})
            .safeAreaInset(edge: .bottom, content: {orderButtonView})
            .overlay(titleBackground, alignment: .top)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $foodVM.navigateToRestaurantBookingView) {RestaurantBookingView(bookVM: bookVM, schemeVM: schemeVM)}
            .navigationDestination(isPresented: $foodVM.showOrderView) {
                OrderView(bookVM: bookVM, schemeVM: schemeVM)
            }
        }
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView(bookVM: BookViewModel(restaurant: dev.restaurant), schemeVM: SchemeViewModel(restaurantId: dev.restaurant.id))
            .environmentObject(BookViewModel(restaurant: dev.restaurant))
    }
}

extension FoodView{
    private var tabBarView: some View{
        ScrollViewReader { scrollView in
            navBar
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0){
                    ForEach(foodVM.tabBars.indices, id: \.self){ index in
                        LazyVStack{
                            Text(foodVM.tabBars[index].type)
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
                ForEach(foodVM.foodIsLoading ? foodVM.foodPlaceholder.indices : foodVM.foods.indices, id: \.self) { index in
                    if foodVM.foodIsLoading{
                        FoodCardView(food: foodVM.foodIsLoading ? foodVM.foodPlaceholder[index] : foodVM.foods[index], bookVM: bookVM)
                            .padding(10)
                            .redacted(reason: .placeholder)
                    }else{
                        FoodCardView(food: foodVM.foods[index], bookVM: bookVM)
                            .padding(10)
                            .onAppear{
                                if !foodVM.foodIsLoading{
                                    foodVM.requestMoreFoods(index: index)
                                }
                            }
                            .redacted(reason: foodVM.foodIsLoading ? .placeholder : [])
                    }
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
        LazyHStack{
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
    
    private var orderButtonView: some View{
        Button{
            if bookVM.secondaryCheckView{
                dismiss()
                return
            }
            foodVM.navigateToOrderView()
        }label: {
            Text(foodVM.orderButtonLabelText)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Capsule().fill(Color.theme.yellowColor))
                .cornerRadius(10)
        }
        .padding(.horizontal)
        .opacity(foodVM.showOrderButton ? 1.0 : 0.0)
    }
    
    private var restaurantBookingAlertView: some View{
        AlertBuilder(showAlert: $foodVM.showRestaurantBookingAlertView) {
            VStack{
                Text("You have not booked restaurant yet. Before proceeding, please, book a table and time.")
                    .foregroundColor(Color.theme.accent)
                    .multilineTextAlignment(.center)
                    .font(.callout)
                    .fontWeight(.medium)
                HStack{
                    Button{
                        withAnimation {
                            foodVM.openRestaurantBookingViewButtonTapped()
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
                            foodVM.cancelOrderButtonTapped()
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
            .padding()
        }
    }
}
