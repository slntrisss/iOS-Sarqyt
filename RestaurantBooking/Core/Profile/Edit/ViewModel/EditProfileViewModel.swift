//
//  ProfileViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 01.04.2023.
//

import Foundation
import UIKit

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
}
