////
////  AddItemView.swift
////  FigmaToSwiftUI
////
////  Created by Tech Exactly iPhone 6 on 31/01/25.


//import SwiftUI
//
//struct AddItemView: View {
//    @Binding var itemCounts: [UUID: Int] // Keep item counts persistent
//    var selectedItems: [FoodModel]
//
//    @Environment(\.dismiss) var GoBack
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                HStack(alignment: .top) {
//                    Button {
//                        GoBack()
//                    } label: {
//                        Image(systemName: "arrow.backward")
//                            .font(.title2)
//                            .foregroundColor(.black)
//                            .padding()
//                            .background(Color.white)
//                            .clipShape(Circle())
//                            .shadow(radius: 3)
//                    }
//                    Spacer()
//                }
//                .padding(.leading, 20)
//
//                List {
//                    ForEach(selectedItems) { item in
//                        HStack {
//                            // Item Image
//                            Image(item.image) // Ensure image exists in assets
//                                .resizable()
//                                .frame(width: 50, height: 50)
//                                .cornerRadius(10)
//
//                            // Item Details
//                            VStack(alignment: .leading) {
//                                Text(item.title)
//                                    .font(.headline)
//
//                                Text("$\(item.price)")
//                                    .foregroundColor(.gray)
//                            }
//
//                            Spacer()
//
//                            // Quantity Control
//                            HStack {
//                                // Minus Button
//                                Button(action: {
//                                    if let count = itemCounts[item.id], count > 0 {
//                                        itemCounts[item.id] = count - 1
//                                    }
//                                }) {
//                                    Image(systemName: "minus.circle.fill")
//                                        .foregroundColor(itemCounts[item.id, default: 0] > 0 ? .red : .gray)
//                                        .font(.title2)
//                                }
//                                .disabled(itemCounts[item.id, default: 0] <= 0)
//
//                                // Item Count
//                                Text("\(itemCounts[item.id, default: 0])")
//                                    .font(.headline)
//                                    .frame(width: 30, alignment: .center)
//
//                                // Plus Button
//                                Button(action: {
//                                    itemCounts[item.id, default: 0] += 1
//                                }) {
//                                    Image(systemName: "plus.circle.fill")
//                                        .foregroundColor(.green)
//                                        .font(.title2)
//                                }
//                            }
//                        }
//                        .padding(.vertical, 5)
//                    }
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//        .navigationTitle("Cart")
//    }
//}




import SwiftUI

struct AddItemView: View {
    @Binding var itemCounts: [UUID: Int]
    var selectedItems: [FoodModel]
    

    @Environment(\.dismiss) var GoBack

    var cartItems: [FoodModel] {
        selectedItems.filter { itemCounts[$0.id, default: 0] > 0 } // Only show items with count > 0
    }

    var body: some View {
        NavigationStack {
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

                List {
                    ForEach(cartItems) { item in
                        HStack {
                            Image(item.image)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(10)

                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.headline)
                                Text("$\(item.price)")
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            HStack {
                                Button(action: {
                                    if let count = itemCounts[item.id], count > 1 {
                                        itemCounts[item.id] = count - 1
                                    } else {
                                        itemCounts[item.id] = nil // Remove item if count reaches 0
                                    }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(itemCounts[item.id, default: 0] > 0 ? .red : .gray)
                                        .font(.title2)
                                }
                                .disabled(itemCounts[item.id, default: 0] <= 0)

                                Text("\(itemCounts[item.id, default: 0])")
                                    .font(.headline)
                                    .frame(width: 30, alignment: .center)

                                Button(action: {
                                    itemCounts[item.id, default: 0] += 1
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.title2)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Cart")
    }
}



// MARK: - Preview with Mock Data
struct AddItemView_Previews: PreviewProvider {
    @State static var mockCounts: [UUID: Int] = [:]
    
    static var previews: some View {
        let mockItems: [FoodModel] = [
            FoodModel( title: "Pizza", image: "pizza", price: "9.99"),
            FoodModel( title: "Burger", image: "burger", price: "5.99")
        ]
        
        return AddItemView(itemCounts: $mockCounts, selectedItems: mockItems)
    }
}
