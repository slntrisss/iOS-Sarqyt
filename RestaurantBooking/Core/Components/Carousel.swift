//
//  Carousel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 21.02.2023.
//

import SwiftUI

struct Carousel<Content: View, T: Identifiable>: View {
    var list: [T]
    
    var spacing: CGFloat
    var trailingSpace: CGFloat
    var content: (T) -> Content
    
    @GestureState private var offset: CGFloat = 0
    @State private var currentIndex = 0
    
    init(list: [T],
         spacing: CGFloat = 0,
         trailingSpacing: CGFloat = 120,
         @ViewBuilder content: @escaping (T) -> Content){
        self.list = list
        self.spacing = spacing
        self.trailingSpace = trailingSpacing
        self.content = content
    }
    
    var body: some View {
        GeometryReader{ proxy in
            let width = proxy.size.width - (trailingSpace - spacing)
            HStack(spacing: spacing){
                ForEach(list, id: \.id) { item in
                    content(item)
                        .frame(width: abs(proxy.size.width - trailingSpace))
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: CGFloat(currentIndex) * (-width) + xOffset + adjustmentWidth)
            .gesture(dragGesture(width: width))
        }
        .animation(.easeInOut, value: offset)
    }
    
}

struct Carousel_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension Carousel{
    private func dragGesture(width: CGFloat) -> some Gesture{
        DragGesture()
            .updating($offset) { currentState, gestureState, transaction in
                gestureState = currentState.translation.width
            }
            .onEnded { value in
                let xTranslation = value.translation.width
                let translationIndex = (-xTranslation / width).rounded()
                currentIndex = max(min(currentIndex + Int(translationIndex), bounds), 0)
            }
    }
    
    private var bounds: Int{
        return list.count - 1
    }
    
    private var adjustmentWidth: CGFloat{
        if currentIndex > 0 && currentIndex < bounds{
            return (trailingSpace / 2) - spacing
        }
        return 0
    }
    
    private var xOffset: CGFloat{
        return offset + (currentIndex == bounds ? (trailingSpace - (spacing * 2)) : 0)
    }
}
