//
//  PaymentView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 02.04.2023.
//

import SwiftUI

struct PaymentView: View {
    @StateObject private var paymentVM = PaymentViewModel()
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    ForEach(paymentVM.paymentCards) { card in
                        HStack{
                            Image(systemName: "creditcard")
                            Text(paymentVM.getFormattedCardNumber(cardNumber: card.cardNumber))
                                .font(.headline)
                                .foregroundColor(Color.theme.accent)
                            Spacer()
                            Image(systemName: card.inUse ? "circle.circle.fill" : "circle.circle")
                                .foregroundColor(Color.theme.green)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            paymentVM.changeDefaultPaymentCard(card: card)
                        }
                    }
                    .onDelete(perform: paymentVM.delete)
                }
                .listStyle(.inset)
                .toolbar{
                    ToolbarItem(placement:.navigationBarTrailing){
                        HStack{
                            addButton
                            EditButton().foregroundColor(.blue)
                        }
                    }
                }
            }
            .onAppear{
                paymentVM.getCards()
            }
        }
        .sheet(isPresented: $paymentVM.addNewPaymentCard, content: {
            NavigationStack{
                AddPaymentMethodView()
            }
        })
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            PaymentView()
        }
    }
}

extension PaymentView{
    private var addButton: some View{
        Button{
            paymentVM.addNewPaymentCard = true
        }label: {
            Text("Add")
                .foregroundColor(.blue)
        }
    }
}
