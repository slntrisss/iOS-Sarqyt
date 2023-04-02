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
    
    @Published var showLogoutView: Bool = false
    @Published var logout: Bool = false
    
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
    
    //MARK: - OPen Settings
    func openSettings(){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
}
