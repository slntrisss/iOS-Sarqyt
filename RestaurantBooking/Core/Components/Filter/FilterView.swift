//
//  FilterView.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 24.02.2023.
//

import SwiftUI

struct FilterView: View {
    @EnvironmentObject var filterVM: FilterViewModel
    
    @State private var seeAllCountries = false
    @State private var seeAllCategories = false
    @State private var seeAllFacilities = false
    @State private var seeAllAccomodationTypes = false
    
    @State private var resetButtonTapped = false
    @State private var applyButtonTapped = false
    
    let filterData = DeveloperPreview.instance.filterData
    let paddingAmount: CGFloat = 20
    
    var body: some View {
        NavigationStack{
            if filterVM.isLoading{
                ProgressView()
            } else {
                ScrollView(.vertical, showsIndicators: false){
                    header
                        .padding(.top)
                    
                    VStack{
                        cityView
                        categoryView
                        FilterPriceRangeView(paddingAmount: paddingAmount)
                            .environmentObject(filterVM)
                        starRatingView
                        facilitiesView
                        accomodationTypeView
                    }
                    .padding(.bottom)
                    Divider()
                    
                    HStack{
                        SecondaryButton(buttonLabel: "Reset", buttonClicked: $resetButtonTapped)
                        PrimaryButton(buttonLabel: "Apply", buttonClicked: $applyButtonTapped)
                    }
                    .padding(paddingAmount)
                }
                .toolbar{
                    ToolbarItem(placement: .keyboard) {
                        HStack{
                            Button("Done"){
                                filterVM.validateRange()
                                UIApplication.shared.endEditing()
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
        .onAppear{
            filterVM.getFilterData()
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            FilterView()
                .environmentObject(FilterViewModel())
        }
    }
}

extension FilterView{
    private var header: some View{
        Group{
            Capsule()
                .fill(Color.theme.secondaryText)
                .frame(width: 40, height: 5)
            
            Text("Filter Restaurant")
                .font(.title2.weight(.semibold))
                .foregroundColor(Color.theme.accent)
            
            Divider()
        }
    }
    
    private var cityView: some View{
        VStack{
            FilterSectionHeaderView(label: "City", buttonLabel: "See All", buttonTapped: $seeAllCountries)
                .padding(paddingAmount)
            if let filterData = filterVM.filterData{
                CategoryCollectionView(collections: filterData.cities, selectedCollection: $filterVM.selectedCity, leadingSpacing: paddingAmount)
            }
        }
    }
    
    private var categoryView: some View{
        VStack{
            FilterSectionHeaderView(label: "Category", buttonLabel: "See All", buttonTapped: $seeAllCategories)
                .padding(paddingAmount)
            if let filterData = filterVM.filterData{
                CategoryCollectionView(collections: filterData.categories, selectedCollection: $filterVM.selectedCategory, leadingSpacing: paddingAmount)
            }
        }
    }
    
    private var starRatingView: some View{
        VStack{
            FilterSectionHeaderView(label: "Star Rating")
                .padding(paddingAmount)
            if let filterData = filterVM.filterData{
                StarRatingCollectionView(ratings: filterData.ratings, selectedRating: $filterVM.selectedRating, leadingSpacing: paddingAmount)
            }
        }
    }
    
    private var facilitiesView: some View{
        VStack{
            FilterSectionHeaderView(label: "Facilities", buttonLabel: "See All", buttonTapped: $seeAllFacilities)
                .padding(paddingAmount)
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    if let filterData = filterVM.filterData{
                        ForEach(filterData.accomodationTypes.indices , id: \.self) { index in
                            FilterCheckBox(isOn: $filterVM.selectedFacilities[index], text: filterData.facilities[index])
                                .offset(x: paddingAmount)
                                .padding(.trailing, index == filterData.facilities.count - 1 ? paddingAmount : 0)
                        }
                    }
                }
            }
        }
    }
    
    private var accomodationTypeView: some View{
        VStack{
            FilterSectionHeaderView(label: "Accomodation Type", buttonLabel: "See All", buttonTapped: $seeAllAccomodationTypes)
                .padding(paddingAmount)
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    if let filterData = filterVM.filterData{
                        ForEach(filterData.accomodationTypes.indices , id: \.self) { index in
                            FilterCheckBox(isOn: $filterVM.selectedAccomodationTypes[index], text: filterData.accomodationTypes[index])
                                .offset(x: paddingAmount)
                                .padding(.trailing, index == filterData.facilities.count - 1 ? paddingAmount : 0)
                        }
                    }
                }
            }
        }
    }
    
    
    private struct FilterCheckBox: View{
        @Binding var isOn: Bool
        let text: String
        var body: some View{
            HStack{
                Image(systemName: $isOn.wrappedValue ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundColor(Color.theme.green)
                    .onTapGesture {isOn.toggle()}
                Text(text)
                    .font(.title3)
            }
        }
    }
}
