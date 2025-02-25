import SwiftUI

struct HeaderView: View {
    let title: String
    let dismiss: DismissAction
    
    var body: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
                    .imageScale(.large)
            }
            Spacer()
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
        .padding()
    }
} 