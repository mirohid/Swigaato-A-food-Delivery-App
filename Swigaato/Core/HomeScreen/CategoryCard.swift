import SwiftUI

struct CategoryCard: View {
    let category: FoodCategory
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Image(category.image)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.black : Color.clear, lineWidth: 2)
                )
            
            Text(category.name)
                .font(.caption)
                .fontWeight(isSelected ? .bold : .regular)
        }
        .padding(.vertical, 8)
    }
}
