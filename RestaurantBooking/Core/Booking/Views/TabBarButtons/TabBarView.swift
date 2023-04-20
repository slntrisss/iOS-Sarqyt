//
//  TabBarView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 02.03.2023.
//

import SwiftUI

struct TabBarView: View{
    
    @Binding var currentTab: Int
    @Namespace var namespace
    @State private var ongoingTab = 0
    @State private var completedTab = 1
    @State private var cancelledTab = 2
    
    let options = ["Ongoing", "Completed", "Cancelled"]
    var body: some View{
        HStack{
            TabBarItem(currentTab: $currentTab, namespace: namespace, tabBarItemName: "Ongoing", tab: 0)
                .frame(width: UIScreen.main.bounds.width * 0.33)
            TabBarItem(currentTab: $currentTab, namespace: namespace, tabBarItemName: "Completed", tab: 1)
                .frame(width: UIScreen.main.bounds.width * 0.33)
            TabBarItem(currentTab: $currentTab, namespace: namespace, tabBarItemName: "Cancelled", tab: 2)
                .frame(width: UIScreen.main.bounds.width * 0.33)
        }
        .frame(maxWidth: .infinity)
    }
}
