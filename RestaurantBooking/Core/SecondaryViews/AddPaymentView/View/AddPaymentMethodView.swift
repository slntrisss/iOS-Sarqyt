//
//  CardView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 01.04.2023.
//

import SwiftUI
import Combine

struct AddPaymentMethodView: View {
    @StateObject private var addPaymentVM = AddPaymentViewModel()
    @FocusState private var inFocus: AddPaymentViewModel.CardFieldsFocus?
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack{
            ScrollView{
                Image("logo")
                Text("Sarqyt")
                    .font(.title2.weight(.semibold))
                
                VStack(spacing: 10){
                    cardNumberView
                    HStack{
                        VStack(alignment: .leading){
                            Text("Valid untill")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.white)
                                .padding(.top)
                            HStack(spacing: 0){
                                expirationMonthView
                                Text("/")
                                    .frame(width: 20)
                                expirationYearView
                                Spacer()
                                cvvView
                            }
                        }
                        .multilineTextAlignment(.center)
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.theme.green))
            }
            .navigationTitle("Add Payment Method")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .keyboard) {doneButton}
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        addPaymentVM.cancelSaving()
                        dismiss()
                    }label: {
                        Text("Cancel").foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal)
            if addPaymentVM.showProgressView{
                Color.black.opacity(0.15)
                    .ignoresSafeArea(.all)
                ProgressView()
            }
        }
    }
}

struct AddPaymentMethodView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            AddPaymentMethodView()
        }
    }
}

extension AddPaymentMethodView{
    private var cardNumberView: some View{
        TextField("", text: $addPaymentVM.cardNumber, prompt: Text("Card Number").foregroundColor(.white))
            .keyboardType(.numberPad)
            .submitLabel(.next)
            .overlay(Rectangle().fill(.white)
                .frame(height: 1),alignment: .bottom)
            .focused($inFocus, equals: .cardNumber)
            .onReceive(Just($addPaymentVM.cardNumber)) { newValue in
                addPaymentVM.formatCredtCard(number: newValue)
            }
            .onChange(of: addPaymentVM.cardNumber) { _ in
                inFocus = addPaymentVM.cardFieldChnaged(inFocus: _inFocus)
            }
    }
    private var expirationMonthView: some View{
        TextField("", text: $addPaymentVM.expirationMonth, prompt: Text("MM").foregroundColor(.white))
            .keyboardType(.numberPad)
            .frame(width: 40)
            .focused($inFocus, equals: .expirationMonth)
            .overlay(Rectangle().fill(.white)
                .frame(width: 40, height: 1),alignment: .bottom)
            .onChange(of: addPaymentVM.expirationMonth) { _ in
                inFocus = addPaymentVM.cardFieldChnaged(inFocus: _inFocus)
            }
    }
    private var expirationYearView: some View{
        TextField("", text: $addPaymentVM.expirationYear, prompt: Text("YY").foregroundColor(.white))
            .keyboardType(.numberPad)
            .frame(width: 40)
            .focused($inFocus, equals: .expirationYear)
            .overlay(Rectangle().fill(.white)
                .frame(width: 40, height: 1),alignment: .bottom)
            .onChange(of: addPaymentVM.expirationYear) { _ in
                inFocus = addPaymentVM.cardFieldChnaged(inFocus: _inFocus)
            }
    }
    private var cvvView: some View{
        SecureField("", text: $addPaymentVM.CVV, prompt: Text("CVV").foregroundColor(.white))
            .keyboardType(.numberPad)
            .frame(width: 40)
            .focused($inFocus, equals: .cvv)
            .overlay(Rectangle().fill(.white)
                .frame(width: 40, height: 1),alignment: .bottom)
            .onChange(of: addPaymentVM.CVV) { _ in
                inFocus = addPaymentVM.cardFieldChnaged(inFocus: _inFocus)
            }
    }
    private var doneButton: some View{
        HStack{
            Button{
                addPaymentVM.savePaymentCard()
                dismiss()
            }label: {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(addPaymentVM.addPaymentMethodDisabled ? Color.theme.secondaryText.opacity(0.5) : Color.theme.secondaryText)
            }
            .disabled(addPaymentVM.addPaymentMethodDisabled)
            Spacer()
        }
    }
}
