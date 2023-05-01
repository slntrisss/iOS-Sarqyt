//
//  ReserveInfo.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 01.04.2023.
//

import SwiftUI

struct ReserveInfoView: View {
    @ObservedObject var bookingVM: BookingViewModel
    let maxHeight: CGFloat = UIScreen.main.bounds.height * 0.35
    @State private var show = false
    @Environment(\.dismiss) private var dismiss
    
    init(bookingVM: BookingViewModel, restaurantId: String){
        self._bookingVM = ObservedObject(wrappedValue: bookingVM)
        bookingVM.getReservedRestaurantDetail(for: restaurantId)
    }
    var body: some View {
        ZStack{
            if bookingVM.reservationDetailsLoading{
                ProgressView()
            }else{
                ScrollView(.vertical){
                    LazyVStack(alignment: .leading){
                        Image(uiImage: bookingVM.bookingDetail?.wrappedRestaurantImage ?? UIImage(systemName: "photo.fill")!)
                            .resizable()
                            .scaledToFit()
                        
                        LazyVStack{
                            VStack(alignment: .leading){
                                spacer
                                Group{
                                    restaurantInfoView
                                    spacer
                                    tableInfoView
                                    spacer
                                    if !(bookingVM.bookingDetail?.specialWishes.isEmpty ?? true){ specialWishesView }
                                    spacer
                                    orderedFoods
                                }.padding(.horizontal)
                            }
                            .background(Color.theme.background)
                            summaryView
                                .ignoresSafeArea(.all, edges: .bottom)
                        }
                    }
                }
                .navigationTitle("Reserve Info")
                .navigationBarTitleDisplayMode(.inline)
                .ignoresSafeArea(.all, edges: .bottom)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) { dismissButton }
                }
            }
        }
    }
}

struct ReserveInfo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ReserveInfoView(bookingVM: BookingViewModel(), restaurantId: "")
        }
    }
}

extension ReserveInfoView{
    private var spacer: some View{
        Spacer().frame(height: 30)
    }
    private var restaurantInfoView: some View{
        Group{
            Text(bookingVM.bookingDetail?.restaurantName ?? "N/A")
                .font(.title.weight(.semibold))
            HStack{
                Image(systemName: "mappin")
                Text("\(bookingVM.bookingDetail?.city ?? "N/A"), \(bookingVM.bookingDetail?.location ?? "")")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
    private var tableInfoView: some View{
        HStack{
            VStack(spacing: 10){
                Text("№ Table")
                    .foregroundColor(Color.theme.secondaryText)
                Text("\(bookingVM.bookingDetail?.tableNumber ?? -1)")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            
            VStack(spacing: 10){
                Text("Date")
                    .foregroundColor(Color.theme.secondaryText)
                Text(bookingVM.bookingDetail?.reservedDate ?? "N/A")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            
            VStack(spacing: 10){
                Text("Time")
                    .foregroundColor(Color.theme.secondaryText)
                Text(bookingVM.bookingDetail?.reservedTime ?? "N/A")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            
            VStack(spacing: 10){
                Text("Guests")
                    .foregroundColor(Color.theme.secondaryText)
                Text("\(bookingVM.bookingDetail?.numberOfGuests ?? 0)")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
        }
    }
    private var specialWishesView: some View{
        VStack(alignment: .leading, spacing: 10){
            Text("Special wishes")
                .foregroundColor(Color.theme.secondaryText)
            Text(bookingVM.bookingDetail?.specialWishes ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.theme.secondaryText.opacity(0.2))
                )
        }
    }
    private var orderedFoods: some View{
        ForEach(bookingVM.bookingDetail?.orderedFoods ?? []) { orderedFood in
            HStack{
                Image(uiImage: orderedFood.food.wrappedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                VStack(alignment: .leading, spacing: 5){
                    Text(orderedFood.food.name)
                        .font(.headline)
                    HStack{
                        Text(orderedFood.price.toKZTCurrency())
                        Spacer()
                        Text("x\(orderedFood.count)")
                    }
                    .font(.subheadline)
                    .foregroundColor(Color.theme.secondaryText)
                }
            }
        }
    }
    private var summaryView: some View{
        VStack{
            summarySeparatorView()
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
                    Text(bookingVM.bookingDetail?.restaurantBookingPrice.toKZTCurrency() ?? "N/A")
                }
                
                HStack{
                    Text("Food")
                    Spacer()
                    Text(bookingVM.bookingDetail?.orderedFoodsPrice.toKZTCurrency() ?? "N/A")
                }.opacity(bookingVM.bookingDetail?.orderedFoods.isEmpty ?? true ? 0.0 : 1.0)
                
//                HStack{
//                    Text("Service")
//                    Spacer()
//                    Text(14745.0.toKZTCurrency())
//                }
                
                HStack{
                    Text("Total")
                        .font(.title2.weight(.semibold))
                    Spacer()
                    Text(bookingVM.bookingDetail?.totalPrice.toKZTCurrency() ?? "N/A")
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
    private func summarySeparatorView() -> some View{
        let bounds = UIScreen.main.bounds.width
        
        var x:CGFloat = 0
        var y: CGFloat = 0
        
        let factor: CGFloat = 18
        var d: CGFloat = -1
        return Path{ path in
            path.move(to: CGPoint(x: x, y: y))
            while(x < bounds){
                x += 17.0
                d *= -1
                y += (factor * d)
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        .foregroundStyle(
            Color.theme.background.gradient
                .shadow(.inner(color: .white, radius: -1, x: 0, y: 1))
        )
    }
    private var dismissButton: some View{
        Button{
            dismiss()
        }label: {
            Image(systemName: "xmark")
                .font(.headline.weight(.heavy))
        }
    }
}
