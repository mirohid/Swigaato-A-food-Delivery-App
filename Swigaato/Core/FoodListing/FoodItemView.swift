//
//  FoodItemView.swift
//  FigmaToSwiftUI
//
//  Created by Tech Exactly iPhone 6 on 31/01/25.
//


import SwiftUI

struct FoodItemView: View {
    let food: FoodModel
    let isSelected: Bool
    let toggleSelection: () -> Void
    
    let cardWidth: CGFloat = 170  // Set fixed width for the card
    let cardHeight: CGFloat = 200 // Set fixed height for the card

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                // Food Image
                Image(food.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: cardWidth, height: cardHeight * 0.6)  // Adjust image size within card
                    .cornerRadius(15)
                   .clipped()
                    
                // Food Title and Price
                VStack(spacing: 5) {
                    Text(food.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(food.price)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                Spacer()
            }
            .frame(width: cardWidth, height: cardHeight) // Set fixed card dimensions
            .padding(.top, 10)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)

            // Custom + Icon Button
            Button(action: toggleSelection) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.green : Color.black)
                        .frame(width: 40, height: 40)

                    Image(systemName: isSelected ? "checkmark" : "plus")
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
            .padding()
        }
        .padding(.top, 10)
    }
}

struct FoodItemView_Previews: PreviewProvider {
    static var previews: some View {
        FoodItemView(
            food: FoodModel(title: "Pizza", image: "splash", price: "$20"),
            isSelected: false,
            toggleSelection: {}
        )
        .previewLayout(.sizeThatFits)
    }
}
