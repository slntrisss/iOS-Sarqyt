//
//  ProfileViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 01.04.2023.
//

import UIKit

class ProfileViewModel: ObservableObject{
    
    @Published var navigateToEditProfileView = false
    @Published var navigateToPaymentView = false
    @Published var navigateToSecurityView = false
    @Published var navigateToNotificationView = false
    
    var user: User? = nil
    
    init(){
        self.user = getUser()
    }
    
    private func getUser() -> User {
        return DeveloperPreview.instance.user
    }
    
    var profileImage: UIImage? {
        if let profileImage = user?.profileImage{
            return UIImage(named: profileImage)
        }
        return nil
    }
    
    var name: String{
        if let firstName = user?.firstName,
           let lastName = user?.lastName{
            return "\(firstName) \(lastName)"
        }
        return "N/A"
    }
    
    var email: String{
        if let email = user?.email{
            return email
        }
        return "N/A"
    }
}
