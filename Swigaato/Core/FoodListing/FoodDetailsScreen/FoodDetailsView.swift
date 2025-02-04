//
//  FoodDetailsView.swift
//  FigmaToSwiftUI
//
//  Created by Tech Exactly iPhone 6 on 31/01/25.
//

import SwiftUI

struct FoodDetailView: View {
    var food: FoodModel
    
    var body: some View {
        VStack {
            Image(food.image)
                .resizable()
                .scaledToFill()
                .frame(width: 370, height: 370)
                .cornerRadius(15)
                .padding()

            Text(food.title)
                .font(.title)
                .bold()
                .padding(.top)

            Text(food.price)
                .font(.title2)
                .foregroundColor(.gray)
                .padding(.bottom)

            Spacer()
        }
        .padding()
    }
}

struct FoodDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailView(food: FoodModel(title: "food", image: "1burger", price: "200"))
    }
}
