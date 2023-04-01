//
//  PaymentViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 02.04.2023.
//

import Foundation

class PaymentViewModel: ObservableObject{
    @Published var paymentCards: [PaymentCard] = []
    
    @Published var addNewPaymentCard = false
    init(){
        paymentCards = getCards()
    }
    
    private func getCards() -> [PaymentCard]{
        return DeveloperPreview.instance.cards
    }
    
    func getFormattedCardNumber(cardNumber: String) -> String{
        let chars = Array(cardNumber)
        var lastFourNumbers = ""
        var index = 1
        while(index <= 4){
            lastFourNumbers += String(chars[cardNumber.count - index])
            index += 1
        }
        return "•••• •••• •••• " + lastFourNumbers
    }
    
    func changeDefaultPaymentCard(cardId: String){
        if let oldDefaultCardIndex = paymentCards.firstIndex(where: {$0.inUse}){
            paymentCards[oldDefaultCardIndex].inUse = false
        }
        if let newDefaultCardIndex = paymentCards.firstIndex(where: {$0.id == cardId}){
            paymentCards[newDefaultCardIndex].inUse = true
        }
    }
    
    func delete(at offsets: IndexSet){
        paymentCards.remove(atOffsets: offsets)
    }
}
