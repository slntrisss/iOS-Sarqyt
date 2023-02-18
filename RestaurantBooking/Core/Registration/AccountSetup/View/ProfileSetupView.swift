//
//  ProfileSetupView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 15.02.2023.
//

import SwiftUI

struct ProfileSetupView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var dateOfBirth = Date()
    @State private var email = ""
    @State private var phoneNumber = "+7"
    @State private var selectedGender = "Male"
    let genders = ["Male", "Female"]
    @State private var dropDownListExpanded = false
    @State private var continueButtonTapped = false
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var chooseFromLibrary = false
    @State private var takeAPhoto = false
    @FocusState private var inFocus: Field?
    @State private var showErrorAlert = false
    
    var body: some View {
        ZStack{
            ScrollView(.vertical, showsIndicators: false) {
                ProfileImageView(image: selectedImage)
                    .profileImageViewModifier()
                    .onTapGesture {
                        showImagePicker = true
                    }
                    .sheet(isPresented: $takeAPhoto, content: {
                        ImageTaker(takedImage: $selectedImage)
                    })
                    .padding(.vertical)
                
                VStack(spacing: 20){
                    firstNameField
                    lastNameField
                    emailField
                    dateOfBirthField
                    phoneNumberField
                    genderDropDownField
                    PrimaryButton(buttonLabel: "Continue", buttonClicked: $continueButtonTapped)
                }
            }
            .confirmationDialog("Pick a profile choosing option", isPresented: $showImagePicker, actions: { confirmationDialogView })
            .sheet(isPresented: $chooseFromLibrary, content: {ImagePicker(selectedImage: $selectedImage)})
            .padding()
            .navigationTitle("Fill Your Profile")
            .navigationBarTitleDisplayMode(.inline)
            
            errorAlert
        }
    }
}

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ProfileSetupView()
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
        TextField("First Name", text: $firstName)
            .focused($inFocus, equals: .firstName)
            .onSubmit { inFocus = .lastName }
            .submitLabel(.next)
            .emailPasswordMode()
    }
    
    private var lastNameField: some View{
        TextField("First Name", text: $lastName)
            .focused($inFocus, equals: .lastName)
            .onSubmit { inFocus = .email }
            .submitLabel(.next)
            .emailPasswordMode()
    }
    
    private var emailField: some View{
        HStack{
            TextField("Email", text: $email)
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
            DatePicker("Date of birth", selection: $dateOfBirth, displayedComponents: [.date])
                .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                .padding()
                .background(Color.theme.field)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var phoneNumberField: some View{
        //TODO: extract the logic from view
        HStack{
            TextField("Phone number", text: $phoneNumber)
                .focused($inFocus, equals: .phone)
                .onSubmit { inFocus = nil }
                .keyboardType(.numberPad)
                .onChange(of: phoneNumber) { _ in
                    if phoneNumber.count == 0{
                        phoneNumber = "+7"
                    }else if phoneNumber.count > 11{
                        phoneNumber.formatPhoneNumber()
                    }
                }
            
            Image(systemName: "phone.fill")
                .foregroundColor(Color.theme.secondaryText)
        }
        .emailPasswordMode()
    }
    
    private var genderDropDownField: some View{
        DisclosureGroup(selectedGender, isExpanded: $dropDownListExpanded) {
            ForEach(genders, id: \.self) { gender in
                Text(gender)
                    .foregroundColor(Color.theme.secondaryText)
                    .onTapGesture {
                        selectedGender = gender
                        withAnimation {
                            dropDownListExpanded = false
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
                chooseFromLibrary = true
            }
            Button("Take a photo") {
                takeAPhoto = true
            }
            Button("Cancel", role: .cancel){}
        }
    }
    
    //MARK: - Alerts
    
    private var errorAlert: some View{
        AlertBuilder(showAlert: $showErrorAlert) {
            Text("Account setup error")
                .foregroundColor(.red)
                .padding()
            Text("Try to fill all required fields")
                .foregroundColor(Color.theme.secondaryText)
                .padding(.bottom)
            Button("OK"){
                withAnimation {
                    showErrorAlert = false
                }
            }
                .foregroundColor(.blue)
        }
        .onChange(of: continueButtonTapped) { newValue in
            withAnimation {
                showErrorAlert.toggle()
            }
        }
    }
}
