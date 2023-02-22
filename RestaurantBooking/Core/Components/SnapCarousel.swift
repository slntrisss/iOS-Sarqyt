//
//  SnapCarousel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 21.02.2023.
//

import SwiftUI

struct SnapCarousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    @GestureState private var offset: CGFloat = 0
    @State private var currentIndex = 0
    init(spacing: CGFloat = 15,
         trailingSpace: CGFloat = 100,
         index: Binding<Int>,
         items: [T],
         @ViewBuilder content: @escaping (T) -> Content){
        
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    var body: some View {
        GeometryReader{ proxy in
            
            let width = proxy.size.width - (trailingSpace - spacing)
            
            let adjustmentWidth = (trailingSpace / 2) - spacing
            
            ForEach(list) { item in
                HStack(spacing: spacing){
                    ForEach(list){ item in
                        content(item)
                            .frame(width: proxy.size.width - trailingSpace)
                    }
                }
                .padding(.horizontal, spacing)
                .offset(x: CGFloat(currentIndex) * -width + (currentIndex != 0 ? adjustmentWidth : 0) + offset)
                .gesture(
                    DragGesture()
                        .updating($offset, body: { value, out, _ in
                            out = value.translation.width
                        })
                        .onEnded({ value in
                            let offsetX = value.translation.width
                            
                            let progress = -offsetX / width
                            let roundIndex = progress.rounded()
                            currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                            
                            index = currentIndex
                        })
                        .onChanged({ value in
                            let offsetX = value.translation.width
                            
                            let progress = -offsetX / width
                            let roundIndex = progress.rounded()
                            index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        })
                )
            }
        }
        .animation(.easeInOut, value: offset == 0)
    }
}

struct SnapCarousel_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
