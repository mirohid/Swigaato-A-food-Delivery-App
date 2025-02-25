import Foundation

struct FoodCategory: Identifiable {
    let id = UUID()
    let name: String
    let image: String
}

// Sample data
struct CategoryData {
    static let categories = [
        FoodCategory(name: "Pizza", image: "0pizza"),
        FoodCategory(name: "Burger", image: "1burger"),
        FoodCategory(name: "Indian", image: "biryani"),
        FoodCategory(name: "Chinese", image: "chinese"),
        FoodCategory(name: "Desserts", image: "0icecream"),
        FoodCategory(name: "Beverages", image: "beverage")
    ]
}
