//
//  CodeVerificationView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 17.02.2023.
//

import SwiftUI

struct CodeVerificationView: View {
    @State private var firstNumber = ""
    @State private var secondNumber = ""
    @State private var thirdNumber = ""
    @State private var fourthNumber = ""
    @FocusState private var inFocus: Field?
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State private var count = 5
    @State private var resendButtonDisabled = true
    @State private var showLoadingAlert = false
    @State private var showVerificationCodeErrorAlert = false
    @State private var rotate = 0.0
    @State private var validVerificationCode = false
    
    var body: some View {
        ZStack{
            VStack{
                Text("Code has been sent to +7••••••••94")
                    .foregroundColor(Color.theme.secondaryText)
                characterBasedInputField
                resendVerificationCodeView
            }
            .padding()
            .navigationDestination(isPresented: $validVerificationCode, destination: {NewPasswordView()})
            ProcessingView(showProcessingView: $showLoadingAlert)
            invalidCodeAlert
        }
    }
}

struct CodeVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        CodeVerificationView()
    }
}

extension CodeVerificationView{
    
    private enum Field{
        case firstCell, secondCell, thirdCell, fourthCell
    }
    
    private func changeFocusState(){
        switch inFocus{
        case .firstCell:
            if firstNumber.count == 2{
                let numbers = Array(firstNumber)
                firstNumber = String(numbers[0])
                secondNumber = String(numbers[1])
                inFocus = .secondCell
            }
        case .secondCell:
            if secondNumber.count == 2{
                let numbers = Array(secondNumber)
                secondNumber = String(numbers[0])
                thirdNumber = String(numbers[1])
                inFocus = .thirdCell
            }else if secondNumber.count == 0{
                inFocus = .firstCell
            }
        case .thirdCell:
            if thirdNumber.count == 2{
                let numbers = Array(thirdNumber)
                thirdNumber = String(numbers[0])
                fourthNumber = String(numbers[1])
                verify()
                inFocus = .fourthCell
            }else if thirdNumber.count == 0{
                inFocus = .secondCell
            }
        case .fourthCell:
            if fourthNumber.count > 1{
                fourthNumber = String(fourthNumber.dropLast())
            }else if fourthNumber.count == 0{
                inFocus = .thirdCell
            }
        default:
            inFocus = nil
        }
    }
    
    private func updateTimer() {
        count -= 1
        if count < 0{
            resendButtonDisabled = false
        }
    }
    
    private func verify(){
        let code = firstNumber + secondNumber + thirdNumber + fourthNumber
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            showLoadingAlert = true
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if code != "4575"{
                    showVerificationCodeErrorAlert = true
                }else{
                    validVerificationCode = true
                }
                showLoadingAlert = false
                rotate = 0.0
            }
        }
    }
    
    private var invalidCodeAlert: some View{
        AlertBuilder(showAlert: $showVerificationCodeErrorAlert) {
            VStack{
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.yellow)
                
                Text("Code Verification Error!")
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                    .padding(.vertical)
                
                Text("Provided verification code is invalid. Try again.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.theme.secondaryText)
                
                Divider()
                Button{
                    showVerificationCodeErrorAlert = false
                }label: {
                    Text("OK")
                        .foregroundColor(.blue)
                }
            }
            .frame(width: 200, height: 200)
        }
    }
    
    private var characterBasedInputField: some View{
        HStack{
            Group{
                TextField("", text: $firstNumber)
                    .focused($inFocus, equals: .firstCell)
                    .onChange(of: firstNumber, perform: {_ in changeFocusState()})
                TextField("", text: $secondNumber)
                    .focused($inFocus, equals: .secondCell)
                    .onChange(of: secondNumber, perform: {_ in changeFocusState()})
                TextField("", text: $thirdNumber)
                    .focused($inFocus, equals: .thirdCell)
                    .onChange(of: thirdNumber, perform: {_ in changeFocusState()})
                TextField("", text: $fourthNumber)
                    .focused($inFocus, equals: .fourthCell)
                    .onChange(of: fourthNumber, perform: {_ in changeFocusState()})
            }
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .frame(width: 60, height: 50)
            .background(Color.theme.field)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var resendVerificationCodeView: some View{
        HStack(spacing: 0){
            Text("Resend code in ")
            Button{
                count = 5
                resendButtonDisabled = true
            }label: {
                Text(count >= 0 ? "\(count)" : "Resend Code")
                    .foregroundColor(Color.theme.green)
                + Text(count >= 0 ? " s" : "")
            }
            .disabled(resendButtonDisabled)
        }
        .foregroundColor(Color.theme.secondaryText)
        .onReceive(timer) { _ in updateTimer()}
    }
}
