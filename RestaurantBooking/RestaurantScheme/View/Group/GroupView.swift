//
//  GroupView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 08.04.2023.
//

import SwiftUI

struct GroupView: View {
    let mapItemGroup: MapItemGroup
    @Binding var isSelected: Bool
    var body: some View {
        ZStack{
            ForEach(mapItemGroup.tableItem){ item in
                SchemeMapView(mapItem: item, isSelected: $isSelected, disabled: mapItemGroup.reserved)
            }
            ForEach(mapItemGroup.chairItems) { item in
                SchemeMapView(mapItem: item, isSelected: $isSelected, disabled: mapItemGroup.reserved)
            }
            ForEach(mapItemGroup.sofaItems) { item in
                SchemeMapView(mapItem: item, isSelected: $isSelected, disabled: mapItemGroup.reserved)
            }
        }
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView(mapItemGroup: dev.scheme.floors.first!.groups.first!, isSelected: .constant(false))
    }
}
