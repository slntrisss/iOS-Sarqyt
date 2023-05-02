//
//  ProfileViewModel.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 01.04.2023.
//

import UIKit
import Combine

class ProfileViewModel: ObservableObject{
    
    @Published var navigateToEditProfileView = false
    @Published var navigateToPaymentView = false
    @Published var navigateToSecurityView = false
    @Published var navigateToNotificationView = false
    
    @Published var showLogoutView: Bool = false
    @Published var logout: Bool = false
    
    @Published var user: Userr? = nil
    
    let userDataService = ProfileDataService.instance
    var cancellables = Set<AnyCancellable>()
    
    //MARK: Loading view
    @Published var isLoading = true
    let placeholder = DeveloperPreview.instance.user
    init(){
        addSubscribers()
    }
    
    private func getUser() -> Userr {
        return DeveloperPreview.instance.user
    }
    
    var profileImage: UIImage? {
        if let profileImage = user?.profileImage{
            return ImageService.convertBase64ToImage(base64: profileImage)
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
    
    //MARK: - Networking
    func getUser(){
        userDataService.fetchUser()
    }
    
    private func addSubscribers(){
        userDataService.$user
            .sink { [weak self] fetchedUser in
                if let user = fetchedUser{
                    self?.isLoading = false
                    self?.user = user
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: Logout
    func logoutButtonTapped(){
        NavigationUtil.popToRootView()
    }
}
