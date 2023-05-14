//
//  ProfileViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 01.04.2023.
//

import Foundation
import UIKit
import Combine

class EditProfileViewModel: ObservableObject{
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var dateOfBirth = Date()
    @Published var email = ""
    @Published var phoneNumber = "+7"
    @Published var selectedGender = "Male"
    @Published var dropDownListExpanded = false
    @Published var continueButtonTapped = false
    @Published var showImagePicker = false
    @Published var selectedImage: UIImage? = nil
    @Published var chooseFromLibrary = false
    @Published var takeAPhoto = false
    @Published var showErrorAlert = false
    let genders = ["Male", "Female"]
    @Published var user: Userr?
    
    @Published var showProgressView = false
    
    var errorModel: AccountValidationErrorModel? = nil
    let dataService = ProfileDataService.instance
    var cancellables = Set<AnyCancellable>()
    
    init(user: Userr? = nil){
        self.user = user
        if let user = user{
            self.firstName = user.firstName
            self.lastName = user.lastName
            self.dateOfBirth = user.birthDate
            self.email = user.email
            self.phoneNumber = user.phoneNumber
            self.selectedGender = user.gender
            self.selectedImage = ImageService.convertBase64ToImage(base64: user.profileImage)
        }
    }
    
    func saveAccountData(){
        if allFieldsValid{
            showProgressView = true
            let base64Image = ImageService.convertImageToBase64String(image: selectedImage)
            user = Userr(id: UUID().uuidString, profileImage: base64Image, firstName: firstName, lastName: lastName, email: email, birthDate: dateOfBirth, phoneNumber: phoneNumber, gender: selectedGender)
            dataService.save(user: user!)
            addSubscribers()
        }else{
            showErrorAlert = true
        }
    }
    
    private var allFieldsValid: Bool{
        var isValid = true
        errorModel = AccountValidationErrorModel()
        let trimmedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPhoneField = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedFirstName.isEmpty || trimmedFirstName.count < 2 {
            errorModel?.firstnameError = "First name should not be empty and number of characters should be more than 2 letters."
            isValid = false
        }
        if trimmedLastName.isEmpty || trimmedLastName.count < 2 {
            errorModel?.lastnameError = "Last name should not be empty and number of characters should be more than 2 letters."
            isValid = false
        }
        if trimmedPhoneField.isEmpty || trimmedPhoneField.count <= 16{
            errorModel?.phoneNumberError = "Phone number should be at least 11 characters long."
        }
        return isValid
    }
    
    private func addSubscribers(){
        dataService.$user
            .sink { [weak self] fetchedUser in
                print("updated")
                self?.user = fetchedUser
                self?.showProgressView = false
            }
            .store(in: &cancellables)
    }
}
