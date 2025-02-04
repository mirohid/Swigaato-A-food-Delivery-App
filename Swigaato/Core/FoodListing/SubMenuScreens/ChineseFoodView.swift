//
//  ChineseFoodView.swift
//  Swigaato
//
//  Created by Tech Exactly iPhone 6 on 03/02/25.
//

import SwiftUI

struct ChineseFoodView: View {
    @Environment(\.dismiss) var GoBack
    @State private var searchText: String = ""
    
    @FocusState private var isFocused: Bool

    var body: some View {
        ScrollView{
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
            
            // Search Bar
            ZStack(alignment: .trailing) {
                TextField("Search Chinese food...", text: $searchText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .opacity(searchText.isEmpty ? 0 : 1)
                .padding()
            }
            .padding(.horizontal)
            
            
            
        }.navigationBarBackButtonHidden(true)
        
    }
}

struct ChineseFoodView_Previews: PreviewProvider {
    static var previews: some View {
        ChineseFoodView()
    }
}
