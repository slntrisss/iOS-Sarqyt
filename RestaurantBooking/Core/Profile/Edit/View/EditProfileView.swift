//
//  ProfileView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import SwiftUI

struct EditProfileView: View {
    @FocusState private var inFocus: Field?
    @StateObject private var profileVM = EditProfileViewModel()
    var body: some View {
        ZStack{
            ScrollView(.vertical, showsIndicators: false) {
                ProfileImageView(image: profileVM.selectedImage)
                    .profileImageViewModifier()
                    .onTapGesture {
                        profileVM.showImagePicker = true
                    }
                    .sheet(isPresented: $profileVM.takeAPhoto, content: {
                        ImageTaker(takedImage: $profileVM.selectedImage)
                    })
                    .padding(.vertical)
                
                VStack(spacing: 20){
                    firstNameField
                    lastNameField
                    emailField
                    dateOfBirthField
                    phoneNumberField
                    genderDropDownField
                    PrimaryButton(buttonLabel: "Continue", buttonClicked: $profileVM.continueButtonTapped)
                }
            }
            .confirmationDialog("Pick a profile choosing option", isPresented: $profileVM.showImagePicker, actions: { confirmationDialogView })
            .sheet(isPresented: $profileVM.chooseFromLibrary, content: {ImagePicker(selectedImage: $profileVM.selectedImage)})
            .padding()
            .navigationTitle("Edit Your Profile")
            .navigationBarTitleDisplayMode(.inline)
            
            errorAlert
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ProfileSetupView()
        }
    }
}

extension EditProfileView{
    
    private enum Field{
        case firstName, lastName, dateOfBirth, email, phone, gender
    }
    
    
    //MARK: - Input Field
    
    private var firstNameField: some View{
        TextField("First Name", text: $profileVM.firstName)
            .focused($inFocus, equals: .firstName)
            .onSubmit { inFocus = .lastName }
            .submitLabel(.next)
            .emailPasswordMode()
    }
    
    private var lastNameField: some View{
        TextField("First Name", text: $profileVM.lastName)
            .focused($inFocus, equals: .lastName)
            .onSubmit { inFocus = .email }
            .submitLabel(.next)
            .emailPasswordMode()
    }
    
    private var emailField: some View{
        HStack{
            TextField("Email", text: $profileVM.email)
                .focused($inFocus, equals: .email)
                .onSubmit { inFocus = .dateOfBirth }
                .submitLabel(.next)
            Image(systemName: "envelope.fill")
                .foregroundColor(Color.theme.secondaryText)
        }
        .emailPasswordMode()
    }
    
    private var dateOfBirthField: some View{
        Group{
            DatePicker("Date of birth", selection: $profileVM.dateOfBirth, displayedComponents: [.date])
                .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                .padding()
                .background(Color.theme.field)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var phoneNumberField: some View{
        //TODO: extract the logic from view
        HStack{
            TextField("Phone number", text: $profileVM.phoneNumber)
                .focused($inFocus, equals: .phone)
                .onSubmit { inFocus = nil }
                .keyboardType(.numberPad)
                .onChange(of: profileVM.phoneNumber) { _ in
                    if profileVM.phoneNumber.count == 0{
                        profileVM.phoneNumber = "+7"
                    }else if profileVM.phoneNumber.count > 11{
                        profileVM.phoneNumber.formatPhoneNumber()
                    }
                }
            
            Image(systemName: "phone.fill")
                .foregroundColor(Color.theme.secondaryText)
        }
        .emailPasswordMode()
    }
    
    private var genderDropDownField: some View{
        DisclosureGroup(profileVM.selectedGender, isExpanded: $profileVM.dropDownListExpanded) {
            ForEach(profileVM.genders, id: \.self) { gender in
                Text(gender)
                    .foregroundColor(Color.theme.secondaryText)
                    .onTapGesture {
                        profileVM.selectedGender = gender
                        withAnimation {
                            profileVM.dropDownListExpanded = false
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
                profileVM.chooseFromLibrary = true
            }
            Button("Take a photo") {
                profileVM.takeAPhoto = true
            }
            Button("Cancel", role: .cancel){}
        }
    }
    
    //MARK: - Alerts
    
    private var errorAlert: some View{
        AlertBuilder(showAlert: $profileVM.showErrorAlert) {
            Text("Account setup error")
                .foregroundColor(.red)
                .padding()
            Text("Try to fill all required fields")
                .foregroundColor(Color.theme.secondaryText)
                .padding(.bottom)
            Button("OK"){
                withAnimation {
                    profileVM.showErrorAlert = false
                }
            }
                .foregroundColor(.blue)
        }
        .onChange(of: profileVM.continueButtonTapped) { newValue in
            withAnimation {
                profileVM.showErrorAlert.toggle()
            }
        }
    }
}
