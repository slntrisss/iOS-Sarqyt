//
//  ProfileView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 01.04.2023.
//

import SwiftUI
import UIKit

struct ProfileView: View {
    @StateObject private var profileVM = ProfileViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false) {
                Group{
                    ProfileImageView(image: profileVM.isLoading ? UIImage(named: profileVM.placeholder.profileImage) : profileVM.profileImage)
                        .padding(.vertical)
                    Text(profileVM.isLoading ? profileVM.placeholder.firstName + profileVM.placeholder.lastName : profileVM.name)
                        .font(.title2.weight(.semibold))
                    Text(profileVM.isLoading ? profileVM.placeholder.email : profileVM.email)
                        .font(.subheadline.weight(.medium))
                }
                .redacted(reason: profileVM.isLoading ? .placeholder : [])
                .shimmering(active: profileVM.isLoading)
                Divider()
                VStack(spacing: 30){
                    createNavLinkField(iconName: "person", text: "Edit Profile", fontColor: Color.theme.accent)
                        .onTapGesture {
                            profileVM.navigateToEditProfileView = true
                        }
                        .disabled(profileVM.isLoading)
                    createNavLinkField(iconName: "creditcard", text: "Payment", fontColor: Color.theme.accent)
                        .onTapGesture {
                            profileVM.navigateToPaymentView = true
                        }
                        .disabled(profileVM.isLoading)
                    createNavLinkField(iconName: "bell", text: "Notifications", fontColor: Color.theme.accent)
                        .onTapGesture {
                            profileVM.openSettings()
                        }
                        .disabled(profileVM.isLoading)
                    createNavLinkField(iconName: "lock.shield", text: "Security", fontColor: Color.theme.accent)
                        .onTapGesture {
                            profileVM.navigateToSecurityView = true
                        }
                        .disabled(profileVM.isLoading)
                }
                .padding([.horizontal, .vertical])
                .disabled(profileVM.isLoading)
                logoutButton
                    .unredacted()
            }
            .navigationDestination(isPresented: $profileVM.navigateToEditProfileView, destination: {
                EditProfileView(user: profileVM.user, parentVM: profileVM)
            })
            .navigationDestination(isPresented: $profileVM.navigateToPaymentView, destination: {
                PaymentView()
            })
            .navigationDestination(isPresented: $profileVM.navigateToSecurityView, destination: {
                SecurityView()
            })
            .sheet(isPresented: $profileVM.showLogoutView, content: {
                LogoutView(logout: $profileVM.logout, cancel: $profileVM.showLogoutView)
                    .onChange(of: profileVM.logout) { newValue in
//                        profileVM.logoutButtonTapped()
                        let window = UIApplication.shared.connectedScenes
                            .flatMap{ ($0 as? UIWindowScene)?.windows ?? [] }
                            .first{ $0.isKeyWindow}
                        let newRootView = ContentView() // Create the new root view

                        let transition = UIView.AnimationOptions.transitionFlipFromLeft // Set the transition animation

                        UIView.transition(with: window!, duration: 0.5, options: transition, animations: {
                            window?.rootViewController = UIHostingController(rootView: newRootView) // Set the new root view controller
                        }, completion: nil)

                    }
            })
            .onAppear{
                profileVM.getUser()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ProfileView()
        }
    }
}

extension ProfileView{
    private func createNavLinkField(iconName: String, text: String, fontColor: Color) -> some View{
        HStack{
            Image(systemName: iconName)
            Text(text)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .font(.headline)
        .foregroundColor(fontColor)
    }
    private var logoutButton: some View{
        Button{
            profileVM.showLogoutView = true
        }label: {
            HStack{
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Logout")
            }
            .foregroundColor(.red)
        }
    }
}
