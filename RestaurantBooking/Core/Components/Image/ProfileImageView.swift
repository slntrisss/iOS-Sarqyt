//
//  ProfileImageView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct ProfileImageView: View {
    let image: UIImage?
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .shadow(color: .black, radius: 1, x: 3, y: 0)
        }else{
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
        }
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            ProfileImageView(image: nil)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
                .padding()
            
            ProfileImageView(image: nil)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
