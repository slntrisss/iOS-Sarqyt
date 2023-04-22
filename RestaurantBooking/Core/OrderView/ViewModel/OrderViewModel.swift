//
//  OrderViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 25.03.2023.
//

import Foundation
import SwiftUI
import Combine
import LocalAuthentication

class OrderViewModel: ObservableObject{
    @Published var showAllPaymentsMethodLists = false
    @Published var totalPrice = 0.0
    @Published var bookVM: BookViewModel{
        didSet{
            print("Changing")
        }
    }
    @Published var showFoodView = false
    @Published var showRestaurantBookingView = false
    @Published var confirmButtonTapped = false
    @Published var showCheckmark = -60.0
    var cancellables = Set<AnyCancellable>()
    let bookDataService = BookDataService.instance
    
    @Published var paymentCards: [PaymentCard] = []{
        didSet{
            paymentCards.forEach { card in
                if card.inUse{
                    self.selectedPaymentCard = card
                }
            }
        }
    }
    @Published var showPaymentMethodAlert = false
    @Published var navigateToAddCardView = false
    @Published var selectedPaymentCard: PaymentCard? = nil
    let paymentDataService = PaymentCardDataService.instance
    
    init(bookVM: BookViewModel){
        self.bookVM = bookVM
        addSubscribers()
        getPaymentCards()
    }
    
    var bookingTimeInterval: String{
        return "\(bookedDate)\n\(bookVM.selectedTime)"
    }
    
    var paymentMethodLabel: String{
        if let selectedPaymentCard = selectedPaymentCard{
            return constrcutLabelFor(card: selectedPaymentCard)
        }
        return "Add Payment Method"
    }
    
    func cardLabelFor(card: PaymentCard) -> String {
        return constrcutLabelFor(card: card)
    }
    
    private func constrcutLabelFor(card: PaymentCard) -> String {
        let cardNumber = card.cardNumber
        let chars = Array(cardNumber)
        var lastFourNumbers = ""
        var index = 4
        while(index > 0){
            lastFourNumbers += String(chars[cardNumber.count - index])
            index -= 1
        }
        return "•••• •••• •••• " + lastFourNumbers
    }
    
    private var bookedDate: String{
        return bookVM.selectedDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    func increaseGuestsAmount(){
        if let maxGuestAmount = bookVM.maxGuestsQuantity,
           bookVM.numberOfGuests < maxGuestAmount{
            bookVM.numberOfGuests += 1
        }
    }
    
    func decreaseGuestsAmount(){
        if bookVM.numberOfGuests > 1{
            bookVM.numberOfGuests -= 1
        }
    }
    
    func increaseFoodQuantity(for food: OrderedFood){
        bookVM.orderedFoods[food.id]?.count += 1
    }
    
    func decreaseFoodQuantity(for food: OrderedFood){
        if var foodToBeUpdated = bookVM.orderedFoods[food.id]{
            foodToBeUpdated.count -= 1
            if foodToBeUpdated.count <= 0{
                bookVM.orderedFoods[food.id] = nil
                return
            }
            bookVM.orderedFoods[food.id]?.count = foodToBeUpdated.count
        }
    }
    
    func changeOrderedFoodsButtonTapped(){
        bookVM.secondaryCheckView = true
        showFoodView = true
    }
    
    func changeRestaurantBookingButtonTapped(){
        bookVM.secondaryCheckView = true
        showRestaurantBookingView = true
    }
    
    private func addSubscribers(){
        bookVM.$reservePrice
            .combineLatest(bookVM.$foodPrice)
            .sink { [weak self] (reservePrice, foodPrice) in
                self?.totalPrice = reservePrice + foodPrice
            }
            .store(in: &cancellables)
        
        paymentDataService.$paymentCards
            .sink { [weak self] fetchedPaymentCards in
                self?.paymentCards = fetchedPaymentCards
                print(fetchedPaymentCards)
                print("Cards recieved")
            }
            .store(in: &cancellables)
        
        paymentDataService.$paymentCard
            .sink { [weak self] fetchedCard in
                if let fetchedCard = fetchedCard{
                    self?.paymentCards.append(fetchedCard)
                    self?.selectedPaymentCard = fetchedCard
                }
            }
            .store(in: &cancellables)
    }
    
    func confirm(){
        if selectedPaymentCard == nil {
            showPaymentMethodAlert = true
            return
        }
        checkIdentity()
        if let bookedRestaurant = bookVM.createBookedRestautant(){
            let orderedFoods = bookVM.wrappedOrderedFoods
            bookDataService.bookRestaurant(bookedRestaurant: bookedRestaurant, orderedFoods: orderedFoods)
        }
        
        bookDataService.$restaurantBooked
            .sink { [weak self] isBooked in
                if isBooked != nil{
                    DispatchQueue.main.async {
                        self?.showCheckmark = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        self?.confirmButtonTapped = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        NavigationUtil.popToRootView()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func getPaymentCards(){
        paymentDataService.getPaymentCards()
    }
    
    private func checkIdentity(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Allow to use \"FaceID\" information to unlock the data."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {[weak self] success, error in
                if success{
                    DispatchQueue.main.async {
                        self?.confirmButtonTapped = true
                    }
                } else {
                    print("Error occured while evaluating biometrics")
                }
            }
        } else {
            print("No support for biometrics...")
        }
    }
}
