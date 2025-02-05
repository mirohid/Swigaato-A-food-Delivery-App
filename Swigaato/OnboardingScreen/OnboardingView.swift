//
//  OnboardingView.swift
//  FigmaToSwiftUI
//
//  Created by Tech Exactly iPhone 6 on 29/01/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    
    private let totalPages = 3
    
    var body: some View {
            NavigationStack {
                VStack {
                    TabView(selection: $currentPage) {
                        Image("landing1")
                            .resizable()
                            .scaledToFit()
                        
                            .tag(0)
                        
                        Image("landing2")
                            .resizable()
                            .scaledToFit()
                            .tag(1)
                        
                        Image("landing3")
                            .resizable()
                            .scaledToFit()
                            .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default dots
                    
                    // Custom Progress Indicator
                    HStack(spacing: 8) {
                        ForEach(0..<totalPages, id: \.self) { index in
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(currentPage == index ? .black : .gray.opacity(0.3))
                        }
                    }
                    .padding(.vertical, 20)
                    
                    // Next / Get Started Button
                    if currentPage == totalPages - 1 {
                        NavigationLink(destination: SignUpView()) {
                            Text("Get Started")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 350)
                                .background(Color.black)
                                .cornerRadius(25)
                        }
                        .padding(.bottom, 30)
                    } else {
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 350)
                                .background(Color.black)
                                .cornerRadius(25)
                        }
                        .padding(.bottom, 30)
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                  //  .background(Color(red: 248/255, green: 249/255, blue: 251/255))
                    
            }
        }
    }

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
