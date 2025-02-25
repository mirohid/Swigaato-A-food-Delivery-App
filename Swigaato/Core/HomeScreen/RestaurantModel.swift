import Foundation

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let rating: Double
    let deliveryTime: String
    let priceRange: String
    let cuisineType: String
}

// Sample data
struct RestaurantData {
    static let restaurants = [
        Restaurant(name: "Pizza Hut", image: "pizzahut", rating: 4.5,
                  deliveryTime: "25-30 min", priceRange: "$$", cuisineType: "Italian"),
        Restaurant(name: "Burger King", image: "Bking", rating: 4.2,
                  deliveryTime: "20-25 min", priceRange: "$", cuisineType: "Fast Food"),
        Restaurant(name: "Kfc", image: "kfc", rating: 4.7,
                  deliveryTime: "30-35 min", priceRange: "$$$", cuisineType: "Indian"),
        
        Restaurant(name: "Pizza Hub", image: "restaurant1", rating: 4.5,
                  deliveryTime: "25-30 min", priceRange: "$$", cuisineType: "Italian"),
        Restaurant(name: "Burger King", image: "restaurant2", rating: 4.2,
                  deliveryTime: "20-25 min", priceRange: "$", cuisineType: "Fast Food"),
        Restaurant(name: "Indian Spice", image: "restaurant3", rating: 4.7,
                  deliveryTime: "30-35 min", priceRange: "$$$", cuisineType: "Indian")
    ]
}
