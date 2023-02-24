//
//  PriceSliderView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 24.02.2023.
//

import SwiftUI

struct PriceSliderView: View {
    @State private var x1: CGFloat
    @State private var x2: CGFloat
    @Binding var fromAmount: Int
    @Binding var tillAmount: Int
    let minPriceAmount: Int
    let maxPriceAmount: Int
    let totalWidth: CGFloat
    
    init(minPriceAmount: Int,
         maxPriceAmount: Int,
         fromAmount: Binding<Int>,
         tillAmount: Binding<Int>,
         totalWidth: CGFloat){
        
        self.totalWidth = totalWidth
        self.minPriceAmount = minPriceAmount
        self.maxPriceAmount = maxPriceAmount
        self._fromAmount = fromAmount
        self._tillAmount = tillAmount
        self._fromAmount = fromAmount
        self._tillAmount = tillAmount
        
        x1 = 0.0
        x2 = totalWidth - 40
    }
    
    var body: some View {
        ZStack(alignment: .leading){
            Rectangle()
                .fill(Color.theme.secondaryText.opacity(0.2))
                .frame(maxWidth: .infinity, maxHeight: 5)
            Rectangle()
                .fill(.green)
                .offset(x: x1)
                .frame(width: (x2 - x1) + 20, height: 5)
            HStack(spacing: 0) {
                priceCircle
                    .offset(x: x1)
                    .gesture(x1Gesture)
                priceCircle
                    .offset(x: x2)
                    .gesture(x2Gesture)
            }
        }
    }
}

struct PriceSliderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PriceSliderView(minPriceAmount: 1_000, maxPriceAmount: 10_000, fromAmount: .constant(1_000), tillAmount: .constant(10_000), totalWidth: UIScreen.main.bounds.width)
                .previewLayout(.sizeThatFits)
            
            PriceSliderView(minPriceAmount: 1_000, maxPriceAmount: 10_000, fromAmount: .constant(1_000), tillAmount: .constant(10_000), totalWidth: UIScreen.main.bounds.width)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension PriceSliderView{
    private var priceCircle: some View{
        Circle()
            .strokeBorder(Color.theme.green, lineWidth: 4)
            .frame(width: 20, height: 20)
            .background(Color.theme.background)
            .clipShape(Circle())
    }
    
    private var x1Gesture: some Gesture{
        DragGesture()
            .onChanged({ val in
                if val.location.x >= 0 && val.location.x <= x2 {
                    self.x1 = val.location.x
                    self.fromAmount = Int((diff * x1) / lineWidth) + minPriceAmount
                }
            })
    }
    
    private var x2Gesture: some Gesture{
        DragGesture()
            .onChanged({ val in
                if val.location.x >= x1 && val.location.x <= lineWidth{
                    self.x2 = val.location.x
                    self.tillAmount = Int((diff * x2) / lineWidth) + minPriceAmount
                }
            })
    }
    
    private var diff: CGFloat{
        return CGFloat(maxPriceAmount - minPriceAmount) - 40
    }
    private var lineWidth: CGFloat{
        return totalWidth - 40
    }
}
