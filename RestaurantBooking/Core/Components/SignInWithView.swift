//
//  SignInWithView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct SignInWithView: View {
    @Binding var signInWithGoogleTapped: Bool
    @Binding var signInWithMetaTapped: Bool
    @Binding var signInWithAppleTapped: Bool
    var body: some View {
        HStack(spacing: 30){
            googleSignInView
            metaSignInView
            appleSignInView
        }
    }
}

struct SignInWithView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SignInWithView(signInWithGoogleTapped: .constant(false), signInWithMetaTapped: .constant(false), signInWithAppleTapped: .constant(false))
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            SignInWithView(signInWithGoogleTapped: .constant(false), signInWithMetaTapped: .constant(false), signInWithAppleTapped: .constant(false))
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension SignInWithView{
    
    
    private var googleSignInView: some View{
        Button{
            signInWithGoogleTapped = true
        }label: {
            Image("google-logo")
                .resizable()
                .frame(width: 40, height: 40)
                .padding()
                .background(
                    Color.theme.field
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.theme.secondaryText, lineWidth: 2)
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var metaSignInView: some View{
        Button{
            signInWithMetaTapped = true
        }label: {
            Image("meta-logo")
                .resizable()
                .frame(width: 40, height: 40)
                .padding()
                .background(
                    Color.theme.field
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.theme.secondaryText, lineWidth: 2)
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var appleSignInView: some View{
        Button{
            signInWithAppleTapped = true
        }label: {
            Image("apple-logo")
                .resizable()
                .frame(width: 40, height: 40)
                .padding()
                .background(
                    Color.theme.field
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.theme.secondaryText, lineWidth: 2)
                        )
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    
}
