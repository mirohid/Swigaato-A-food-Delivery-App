//
//  IndianFoodView.swift
//  Swigaato
//
//  Created by Tech Exactly iPhone 6 on 03/02/25.
//

//import SwiftUI
//
//struct IndianFoodView: View {
//    @Environment(\.dismiss) var GoBack
//
//    @State private var searchText: String = ""
//    @State private var selectedItems: Set<UUID> = [] // Track selected items
//    @State private var showCart: Bool = false // Control navigation to AddItemView
//    @State private var selectedFood: FoodModel? // Track selected food item for sheet
//    @State private var itemCounts: [UUID: Int] = [:] // Track item counts
//
//    let foodItemsIndian = FoodDataIndian.foodItemsIndian
//
//    var filteredItems: [FoodModel] {
//        if searchText.isEmpty {
//            return foodItemsIndian
//        } else {
//            return foodItemsIndian.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
//        }
//    }
//
//    var selectedFoodItems: [FoodModel] {
//        foodItemsIndian.filter { selectedItems.contains($0.id) }
//    }
//
//
//
//    var body: some View {
//        VStack{
//            HStack(alignment: .top) {
//                Button {
//                    GoBack()
//                } label: {
//                    Image(systemName: "arrow.backward")
//                        .font(.title2)
//                        .foregroundColor(.black)
//                        .padding()
//                        .background(Color.white)
//                        .clipShape(Circle())
//                        .shadow(radius: 3)
//                }
//
//                Spacer()
//            }
//            .padding(.leading, 20)
//
//            // Search Bar
//            ZStack(alignment: .trailing) {
//                TextField("Search Indian food...", text: $searchText)
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(10)
//                    .shadow(radius: 1)
//
//                Button(action: {
//                    searchText = ""
//                }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundColor(.gray)
//                }
//                .opacity(searchText.isEmpty ? 0 : 1)
//                .padding()
//            }
//            .padding(.horizontal)
//            .navigationBarBackButtonHidden(true)
//            //---//
//
//            // Food Grid View
//            ScrollView {
//                //----//
//                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
//                    ForEach(filteredItems) { item in
//                        FoodItemView(food: item, isSelected: selectedItems.contains(item.id)) {
//                            if selectedItems.contains(item.id) {
//                                selectedItems.remove(item.id)
//                                itemCounts[item.id] = nil // Remove item from count when deselected
//                            } else {
//                                selectedItems.insert(item.id)
//                                itemCounts[item.id] = 1 // Set initial count to 1
//                            }
//                        }.onTapGesture {
//                            selectedFood = item
//                        }
//                    }
//                }
//                .padding()
//            }
//            Spacer()
//
//            // Navigation to AddItemView
//            NavigationLink(destination: AddItemView(itemCounts: $itemCounts, selectedItems: selectedFoodItems), isActive: $showCart) {
//                EmptyView()
//            }
//
//        }
//    }
//
//}
//struct IndianFoodView_Previews: PreviewProvider {
//    static var previews: some View {
//        IndianFoodView()
//    }
//}


//import SwiftUI
//
//struct IndianFoodView: View {
//    @Environment(\.dismiss) var GoBack
//
//    @State private var searchText: String = ""
//    @State private var selectedItems: Set<UUID> = [] // Track selected items
//    @State private var showCart: Bool = false // Control navigation to AddItemView
//    @State private var selectedFood: FoodModel? // Track selected food item for sheet
//    @State private var itemCounts: [UUID: Int] = [:] // Track item counts
//
//    let foodItemsIndian = FoodDataIndian.foodItemsIndian
//
//    var filteredItems: [FoodModel] {
//        if searchText.isEmpty {
//            return foodItemsIndian
//        } else {
//            return foodItemsIndian.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
//        }
//    }
//
//    var selectedFoodItems: [FoodModel] {
//        foodItemsIndian.filter { selectedItems.contains($0.id) }
//    }
//
//    var body: some View {
//        VStack {
//            HStack(alignment: .top) {
//                Button {
//                    GoBack()
//                } label: {
//                    Image(systemName: "arrow.backward")
//                        .font(.title2)
//                        .foregroundColor(.black)
//                        .padding()
//                        .background(Color.white)
//                        .clipShape(Circle())
//                        .shadow(radius: 3)
//                }
//
//                Spacer()
//            }
//            .padding(.leading, 20)
//
//            // Search Bar
//            ZStack(alignment: .trailing) {
//                TextField("Search Indian food...", text: $searchText)
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(10)
//                    .shadow(radius: 1)
//
//                Button(action: {
//                    searchText = ""
//                }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundColor(.gray)
//                }
//                .opacity(searchText.isEmpty ? 0 : 1)
//                .padding()
//            }
//            .padding(.horizontal)
//            .navigationBarBackButtonHidden(true)
//
//            // Food Grid View
//            ScrollView {
//                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
//                    ForEach(filteredItems) { item in
//                        FoodItemView(food: item, isSelected: selectedItems.contains(item.id)) {
//                            if selectedItems.contains(item.id) {
//                                selectedItems.remove(item.id)
//                                itemCounts[item.id] = nil // Remove item from count when deselected
//                            } else {
//                                selectedItems.insert(item.id)
//                                itemCounts[item.id] = 1 // Set initial count to 1
//                            }
//                        }.onTapGesture {
//                            selectedFood = item
//                        }
//                    }
//                }
//                .padding()
//            }
//            Spacer()
//
//            // Navigation to AddItemView
//            NavigationLink(destination: AddItemView(itemCounts: $itemCounts, selectedItems: selectedFoodItems), isActive: $showCart) {
//                EmptyView()
//            }
//
//        }
//    }
//}

import SwiftUI

struct IndianFoodView: View {
    @Environment(\.dismiss) var GoBack
    
    @Binding var selectedItems: Set<UUID> // Pass binding from HomeView
    @Binding var itemCounts: [UUID: Int] // Pass binding from HomeView
    
    @State private var searchText: String = ""
    @State private var selectedFood: FoodModel? // Track selected food item for sheet
    
    let foodItemsIndian = FoodDataIndian.foodItemsIndian
    
    var filteredItems: [FoodModel] {
        if searchText.isEmpty {
            return foodItemsIndian
        } else {
            return foodItemsIndian.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var selectedFoodItems: [FoodModel] {
        foodItemsIndian.filter { selectedItems.contains($0.id) }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Button {
                    GoBack()
                } label: {
                    Image(systemName: "arrow.backward")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                
                Spacer()
            }
            .padding(.leading, 20)
            
            // Search Bar
            ZStack(alignment: .trailing) {
                TextField("Search Indian food...", text: $searchText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .opacity(searchText.isEmpty ? 0 : 1)
                .padding()
            }
            .padding(.horizontal)
            .navigationBarBackButtonHidden(true)
            
            // Food Grid View
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(filteredItems) { item in
                        FoodItemView(food: item, isSelected: selectedItems.contains(item.id)) {
                            if selectedItems.contains(item.id) {
                                selectedItems.remove(item.id)
                                itemCounts[item.id] = nil // Remove item from count when deselected
                            } else {
                                selectedItems.insert(item.id)
                                itemCounts[item.id] = 1 // Set initial count to 1
                            }
                        }.onTapGesture {
                            selectedFood = item
                        }
                    }
                }
                .padding()
            }
            Spacer()
            
            // Navigation to AddItemView
            NavigationLink(destination: AddItemView(itemCounts: $itemCounts, selectedItems: selectedFoodItems), isActive: .constant(false)) {
                EmptyView()
            }
            
        }
    }
}



struct IndianFoodView_Previews: PreviewProvider {
    @State static var selectedItems: Set<UUID> = []
    @State static var itemCounts: [UUID: Int] = [:]

    static var previews: some View {
        IndianFoodView(selectedItems: $selectedItems, itemCounts: $itemCounts)
    }
}
