//
//  PopupViewBuilder.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 23.02.2023.
//

import SwiftUI

struct PopupViewBuilder: View {
    @Binding var restaurant: Restaurant
    @Binding var showPopupView:Bool
    @State private var cancelButtonTapped = false
    @State private var removeButtonTapped = false
    
    @GestureState private var offset: CGFloat = 0.0
    var body: some View {
        ZStack(alignment: .bottom){
            if showPopupView{
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                ZStack{
                    VStack{
                        Capsule()
                            .fill(Color.theme.secondaryText.opacity(0.5))
                            .frame(width: 40, height: 5)
                            .padding(.bottom)
                        Text("Remove from bookmark?")
                            .font(.title.weight(.semibold))
                            .foregroundColor(Color.theme.accent)
                        Divider()
                        RestaurantCardView(restaurant: $restaurant)
                            .padding(.vertical)
                        HStack{
                            SecondaryButton(buttonLabel: "Cancel", buttonClicked: $cancelButtonTapped)
                            PrimaryButton(buttonLabel: "Yes, Remove", buttonClicked: $removeButtonTapped)
                        }
                        .padding(.bottom, 30)
                    }
                    .padding()
                    .background(Color.theme.sheetBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .offset(y: offset)
                .gesture(gesture)
            }
        }
        .ignoresSafeArea(.all)
    }
    
    private var gesture: some Gesture{
        DragGesture()
            .updating($offset) { value, currentState, _ in
                let yTranslation = value.translation.height
                if yTranslation > 0{
                    currentState = yTranslation
                }
            }
            .onEnded { value in
                let yTranslation = value.translation.height
                let screenHeight = UIScreen.main.bounds.height
                let minHeight = CGFloat(screenHeight * 0.8)
                if yTranslation >= minHeight{
                    withAnimation {
                        showPopupView = false
                    }
                }
            }
    }
}

struct PopupViewBuilder_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PopupViewBuilder(restaurant: .constant(dev.restaurant), showPopupView: .constant(true))
        }
    }
}
