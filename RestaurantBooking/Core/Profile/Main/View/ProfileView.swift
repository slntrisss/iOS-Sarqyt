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
    var body: some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: false) {
                ProfileImageView(image: profileVM.profileImage)
                    .padding(.vertical)
                Text(profileVM.name)
                    .font(.title2.weight(.semibold))
                Text(profileVM.email)
                    .font(.subheadline.weight(.medium))
                Divider()
                VStack(spacing: 30){
                    createNavLinkField(iconName: "person", text: "Edit Profile", fontColor: Color.theme.accent)
                        .onTapGesture {
                            profileVM.navigateToEditProfileView = true
                        }
                    createNavLinkField(iconName: "creditcard", text: "Payment", fontColor: Color.theme.accent)
                        .onTapGesture {
                            profileVM.navigateToPaymentView = true
                        }
                    createNavLinkField(iconName: "bell", text: "Notifications", fontColor: Color.theme.accent)
                        .onTapGesture {
                            profileVM.openSettings()
                        }
                    createNavLinkField(iconName: "lock.shield", text: "Security", fontColor: Color.theme.accent)
                        .onTapGesture {
                            profileVM.navigateToSecurityView = true
                        }
                }
                .padding([.horizontal, .vertical])
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
            })
            .safeAreaInset(edge: .bottom) { logoutButton }
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
