//
//  NumberPadView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 30.04.2023.
//

import SwiftUI

struct NumberPadView: View {
    @ObservedObject var passcodeVM = PasscodeViewModel(type: .createdPasscode)
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack{
            dismissButton
            topLabel
            if passcodeVM.type == .passcode{
                progressCircles
            }else{
                createPasscodeCirclesView
            }
            numberPad
        }
        .alert(passcodeVM.bioAlertTile, isPresented: $passcodeVM.showBiometricsAlert, actions: {
            Button("OK"){}
        }, message: {
            Text(passcodeVM.bioAlertMessage)
        })
        .alert("Invalid Passcode", isPresented: $passcodeVM.passcodeNotValid, actions: {
            Button("OK"){}
        }, message: {
            Text("Provided passcode is not valid. Try again.")
        })
        .onAppear{
            passcodeVM.checkBioIdentity()
        }
        .onChange(of: passcodeVM.authSuccess) { newValue in
            if passcodeVM.authSuccess{
                dismiss()
            }
        }
    }
    
    private var dismissButton: some View{
        HStack{
            Button{
                withAnimation(.spring()){
                    dismiss()
                }
            }label: {
                Image(systemName: "xmark")
                    .font(.headline)
            }
            Spacer()
        }
        .opacity(passcodeVM.type == .passcode ? 1.0 : 0.0)
        .padding(.horizontal)
    }
    
    private var topLabel: some View{
        VStack{
            if !passcodeVM.showLockInfoLabel{
                Text(passcodeVM.topLabelText)
            }else{
                Image(systemName: "faceid")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .padding()
                    .background(Color.theme.secondaryText.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text("Face ID or passcode")
                    .foregroundColor(Color.theme.accent)
                    .font(.title3)
            }
        }
        .padding(.top, 20)
    }
    
    private var progressCircles: some View{
        HStack{
            ForEach(0..<4, id: \.self){ val in
                Circle()
                    .strokeBorder(Color.theme.secondaryText, lineWidth: 2)
                    .overlay(Circle().fill(!passcodeVM.displayCircles(index: val) ? .clear : Color.theme.green))
                    .frame(width: 10)
                    .padding(.leading, val == 0 ? 0 : 20)
            }
        }
    }
    
    private var createPasscodeCirclesView: some View{
        ScrollViewReader{ val in
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(0..<2, id: \.self){ index in
                        HStack{
                            ForEach(0..<4, id: \.self){ val in
                                Circle()
                                    .strokeBorder(Color.theme.secondaryText, lineWidth: 2)
                                    .overlay(Circle().fill(!passcodeVM.displayCircles(index: val) ? .clear : Color.theme.green))
                                    .frame(width: 10)
                                    .padding(.leading, val == 0 ? 0 : 20)
                            }
                        }
                        .id(index)
                        .onChange(of: passcodeVM.type) { _ in
                            withAnimation(.spring()){
                                val.scrollTo(passcodeVM.scrollToIndex)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width)
                    }
                }
            }
            .scrollDisabled(true)
        }
    }
    private var numberPad: some View{
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
            ForEach(1...9, id: \.self){ val in
                labelGenerator(val: val)
            }
            bioIcon
            labelGenerator(val: 0)
            deleteButton
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
        .padding(.bottom, UIScreen.main.bounds.height * 0.1)
    }
    
    private func labelGenerator(val: Int) -> some View{
        Button{
            passcodeVM.numberTapped(number: val)
        }label: {
            Circle()
                .fill(Color.theme.secondaryText.opacity(0.5))
                .frame(width: 50)
                .overlay(
                    Circle()
                        .fill(.white)
                        .frame(width: 48)
                        .overlay(
                            Text("\(val)")
                                .font(.headline)
                        )
                )
        }
    }
    
    private var deleteButton: some View{
        Button{
            passcodeVM.deleteNumber()
        }label: {
            Image(systemName: "delete.left")
                .resizable()
                .scaledToFit()
                .fontWeight(.thin)
                .frame(width: 40, height: 20)
        }
    }
    
    private var bioIcon: some View{
        Button{
            passcodeVM.checkBioIdentity()
        }label: {
            Image(systemName: passcodeVM.bioImageName)
                .resizable()
                .scaledToFit()
                .fontWeight(.thin)
                .frame(width: 40, height: 40)
        }
        .opacity(passcodeVM.showBioIDIcon ? 1.0 : 0.0)
    }
}

struct NumberPadView_Previews: PreviewProvider {
    static var previews: some View {
        NumberPadView(passcodeVM: PasscodeViewModel(type: .createdPasscode))
    }
}
