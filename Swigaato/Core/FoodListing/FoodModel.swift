//
//  FoodModel.swift
//  FigmaToSwiftUI
//
//  Created by Tech Exactly iPhone 6 on 31/01/25.
//

import Foundation

struct FoodModel: Identifiable {
    let id: UUID = UUID()
    let title: String
    let image: String
    let price: String
}
