import SwiftUI

struct RestaurantCard: View {
    let restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(restaurant.image)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 150)
                .clipped()
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.headline)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", restaurant.rating))
                    Text("•")
                    Text(restaurant.deliveryTime)
                }
                .font(.caption)
                
                Text(restaurant.cuisineType)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(restaurant.priceRange)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .frame(width: 200)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
