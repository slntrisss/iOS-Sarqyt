//
//  TabBarItem.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 02.03.2023.
//

import SwiftUI

struct TabBarItem: View{
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    let tabBarItemName: String
    var tab: Int
    
    var body: some View{
        Button{
            currentTab = tab
        }label: {
            VStack{
                Text(tabBarItemName)
                if currentTab == tab{
                    Color.theme.green
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "undeline",
                                               in: namespace,
                                               properties: .frame)
                }
            }
            .animation(.spring(), value: currentTab)
        }
        .buttonStyle(.plain)
    }
}
