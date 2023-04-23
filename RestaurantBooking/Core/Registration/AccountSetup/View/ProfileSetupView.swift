//
//  ProfileSetupView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct ProfileSetupView: View {
    @StateObject private var vm = AccountSetupViewModel()
    @FocusState private var inFocus: Field?
    @Binding var isAuthenticated: Bool
    var body: some View {
        ZStack{
            ScrollView(.vertical, showsIndicators: false) {
                ProfileImageView(image: vm.selectedImage)
                    .profileImageViewModifier()
                    .onTapGesture {
                        vm.showImagePicker = true
                    }
                    .sheet(isPresented: $vm.takeAPhoto, content: {
                        ImageTaker(takedImage: $vm.selectedImage)
                    })
                    .padding(.vertical)
                
                VStack(spacing: 20){
                    firstNameField
                    lastNameField
                    dateOfBirthField
                    phoneNumberField
                    genderDropDownField
                    PrimaryButton(buttonLabel: "Continue", buttonClicked: $vm.continueButtonTapped)
                        .onChange(of: vm.continueButtonTapped) { _ in
                            vm.saveAccountData()
                        }
                        .onChange(of: vm.navigateToMainView) { _ in
                            isAuthenticated = vm.navigateToMainView
                            print("Changed, is authenticated: \(isAuthenticated)")
                        }
                }
            }
            .confirmationDialog("Pick a profile choosing option", isPresented: $vm.showImagePicker, actions: { confirmationDialogView })
            .sheet(isPresented: $vm.chooseFromLibrary, content: {ImagePicker(selectedImage: $vm.selectedImage)})
            .padding()
            .navigationTitle("Fill Your Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            
            errorAlert
        }
    }
}

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ProfileSetupView(isAuthenticated: .constant(false))
                .preferredColorScheme(.dark)
        }
    }
}

extension ProfileSetupView{
    
    private enum Field{
        case firstName, lastName, dateOfBirth, email, phone, gender
    }
    
    
    //MARK: - Input Field
    
    private var firstNameField: some View{
        VStack(alignment: .leading){
            TextField("First Name", text: $vm.firstName)
                .focused($inFocus, equals: .firstName)
                .onSubmit { inFocus = .lastName }
                .submitLabel(.next)
                .emailPasswordMode()
            if let errorMessage = vm.errorModel?.firstnameError{
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    private var lastNameField: some View{
        VStack(alignment: .leading){
            TextField("First Name", text: $vm.lastName)
                .focused($inFocus, equals: .lastName)
                .onSubmit { inFocus = .email }
                .submitLabel(.next)
                .emailPasswordMode()
            if let errorMessage = vm.errorModel?.lastnameError{
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    private var dateOfBirthField: some View{
        Group{
            DatePicker("Date of birth", selection: $vm.dateOfBirth, displayedComponents: [.date])
                .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                .padding()
                .background(Color.theme.field)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var phoneNumberField: some View{
        VStack(alignment: .leading){
            HStack{
                TextField("Phone number", text: $vm.phoneNumber)
                    .focused($inFocus, equals: .phone)
                    .onSubmit { inFocus = nil }
                    .keyboardType(.numberPad)
                    .onChange(of: vm.phoneNumber) { _ in
                        
                        if vm.phoneNumber.count == 0{
                            vm.phoneNumber = "+7"
                        }else if vm.phoneNumber.count > 11{
                            vm.phoneNumber.formatPhoneNumber()
                        }
                    }
                
                Image(systemName: "phone.fill")
                    .foregroundColor(Color.theme.secondaryText)
            }
            .emailPasswordMode()
            if let errorMessage = vm.errorModel?.phoneNumberError{
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    private var genderDropDownField: some View{
        DisclosureGroup(vm.selectedGender, isExpanded: $vm.dropDownListExpanded) {
            ForEach(vm.genders, id: \.self) { gender in
                Text(gender)
                    .foregroundColor(Color.theme.secondaryText)
                    .onTapGesture {
                        vm.selectedGender = gender
                        withAnimation {
                            vm.dropDownListExpanded = false
                        }
                    }
            }
        }
        .padding()
        .background(Color.theme.field)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var confirmationDialogView: some View{
        Group{
            Button("Choose from Photo Library"){
                vm.chooseFromLibrary = true
            }
            Button("Take a photo") {
                vm.takeAPhoto = true
            }
            Button("Cancel", role: .cancel){}
        }
    }
    
    //MARK: - Alerts
    
    private var errorAlert: some View{
        AlertBuilder(showAlert: $vm.showErrorAlert) {
            Text("Account setup error")
                .foregroundColor(.red)
                .padding()
            Button("OK"){
                withAnimation {
                    vm.showErrorAlert = false
                }
            }
                .foregroundColor(.blue)
        }
    }
}
