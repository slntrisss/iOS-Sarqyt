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
    @Published var user: User?
    
    init(user: User? = nil){
        self.user = user
        if let user = user{
            self.firstName = user.firstName
            self.lastName = user.lastName
            self.dateOfBirth = user.birthDate
            self.email = user.email
            self.phoneNumber = user.phoneNumber
            self.selectedGender = user.gender
            self.selectedImage = UIImage(named: user.profileImage)
        }
    }
}
