//
//  AccountSetupViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 22.04.2023.
//

import Foundation
import UIKit
import Combine

class AccountSetupViewModel: ObservableObject{
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var dateOfBirth = Date()
    @Published var phoneNumber = "+7"
    @Published var selectedGender = "Male"
    @Published var dropDownListExpanded = false
    @Published var continueButtonTapped = false
    @Published var showImagePicker = false
    @Published var selectedImage: UIImage? = nil
    @Published var chooseFromLibrary = false
    @Published var takeAPhoto = false
    @Published var showErrorAlert = false
    @Published var userSaved = false
    var errorModel: AccountValidationErrorModel? = nil
    
    let genders = ["Male", "Female"]
    let dataService = ProfileDataService.instance
    var user: Userr? = nil
    var cancellable = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    
    func saveAccountData(){
        if allFieldsValid{
            let base64Image = ImageService.convertImageToBase64String(image: selectedImage)
            user = Userr(id: UUID().uuidString, profileImage: base64Image, firstName: firstName, lastName: lastName, email: "", birthDate: dateOfBirth, phoneNumber: phoneNumber, gender: selectedGender)
            dataService.save(user: user!)
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
        if trimmedPhoneField.isEmpty || trimmedPhoneField.count <= 11{
            errorModel?.phoneNumberError = "Phone number should be at least 11 characters long."
        }
        return isValid
    }
    
    private func addSubscribers(){
        dataService.$user
            .sink { [weak self] fetchedUser in
                if let user = self?.user, let fetchedUser = fetchedUser,
                   user == fetchedUser{
                    DispatchQueue.main.async {
                        self?.userSaved = true
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    struct AccountValidationErrorModel{
        var firstnameError: String?
        var lastnameError: String?
        var phoneNumberError: String?
    }
}
