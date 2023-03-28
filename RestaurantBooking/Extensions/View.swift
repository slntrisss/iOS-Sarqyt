//
//  View.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import Foundation
import SwiftUI

extension View{
    func emailPasswordMode() -> some View{
        modifier(EmailPasswordModifier())
    }
    
    func profileImageViewModifier() -> some View{
        modifier(ProfileImageViewModifier())
    }
    func customConfirmDialog<A: View>(isPresented: Binding<Bool>, @ViewBuilder actions: @escaping () -> A) -> some View {
        return self.modifier(ConfirmationDialogModifier(isPresented: isPresented, actions: actions))
    }
}
