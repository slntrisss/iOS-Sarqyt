//
//  ProcessingView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.02.2023.
//

import SwiftUI

struct ProcessingView: View {
    @Binding var showProcessingView: Bool
    @State private var rotationAngle = 0.0
    var body: some View {
        AlertBuilder(showAlert: $showProcessingView) {
            VStack(spacing: 20){
                Image("loadingState")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(rotationAngle))
                    .animation(.linear(duration: 0.1)
                        .speed(0.1).repeatForever(autoreverses: false), value: rotationAngle)
                
                Text("Processing...")
                    .foregroundColor(Color.theme.secondaryText)
                    .font(.caption)
            }
        }
        .onChange(of: showProcessingView, perform: { newValue in
            if showProcessingView{
                withAnimation {
                    rotationAngle = 360.0
                }
            }
        })
    }
}

struct ProcessingView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingView(showProcessingView: .constant(true))
    }
}
