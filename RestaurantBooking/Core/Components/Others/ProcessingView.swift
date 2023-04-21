//
//  ProcessingView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.02.2023.
//

import SwiftUI

struct ProcessingView: View {
    @Binding var showProcessingView: Bool
    var body: some View {
        if showProcessingView{
            ZStack{
                Color.black.opacity(0.55)
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 20){
                    ProgressView()
                    
                    Text("Processing...")
                        .foregroundColor(Color.theme.secondaryText)
                        .font(.caption)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.theme.sheetBackground))
            }
        }
    }
}

struct ProcessingView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessingView(showProcessingView: .constant(true))
    }
}
