//
//  AddPaymentViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 01.04.2023.
//

import SwiftUI

class AddPaymentViewModel: ObservableObject{
    @Published var cardNumber = ""
    @Published var expirationMonth = ""
    @Published var expirationYear = ""
    @Published var CVV = ""
    
    
    var addPaymentMethodDisabled: Bool{
        if cardNumber.count == 19 && expirationMonth.count == 2 &&
            expirationYear.count == 2 && CVV.count == 3{
            return false
        }
        return true
    }
    
    //MARK: - focus state
    enum CardFieldsFocus{
        case none, cardNumber, expirationMonth, expirationYear, cvv
    }
    
    //MARK: - Mask for credit number
    func formatCredtCard(number: Binding<String>){
        let wrappedNumberValue = number.wrappedValue
        let filtered = wrappedNumberValue.filter { "0123456789".contains($0) }
        let formatted = formatCreditCardNumber(filtered)
        if formatted != wrappedNumberValue {
            self.cardNumber = formatted
        }
    }
    
    private func formatCreditCardNumber(_ input: String) -> String {
        var formatted = ""
        for (index, character) in input.enumerated() {
            if index % 4 == 0 && index > 0 {
                formatted += " "
            }
            formatted.append(character)
        }
        return formatted
    }
    
    func cardFieldChnaged(inFocus: FocusState<CardFieldsFocus?>) -> CardFieldsFocus{
        guard let state = inFocus.wrappedValue else{ return .none}
        switch state{
        case .cardNumber:
            if(self.cardNumber.count == 19){
                return .expirationMonth
            }
        case .expirationMonth:
            if self.expirationMonth.count == 2{
                return .expirationYear
            }
        case .expirationYear:
            if self.expirationYear.count == 2{
                return .cvv
            }
        case .cvv:
            if self.CVV.count > 3{
                self.CVV = String(CVV.dropLast(1))
            }
        default: return state
        }
        return state
    }
}
