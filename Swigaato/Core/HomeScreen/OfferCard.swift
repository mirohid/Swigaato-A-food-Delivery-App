import SwiftUI

struct OfferCard: View {
    let title: String
    let description: String
    let gradient: LinearGradient
    
    init(
        title: String = "50% OFF",
        description: String = "On your first order",
        gradient: LinearGradient = LinearGradient(
            gradient: Gradient(colors: [.purple, .blue]),
            startPoint: .leading,
            endPoint: .trailing
        )
    ) {
        self.title = title
        self.description = description
        self.gradient = gradient
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(gradient)
                .frame(width: 300, height: 150)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(description)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .shadow(radius: 2)
    }
}
