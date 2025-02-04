//
//  LaunchScreenView.swift
//  FigmaToSwiftUI
//
//  Created by Tech Exactly iPhone 6 on 29/01/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive: Bool = false
    @State private var progress: CGFloat = 0.0 // Tracks progress from 0 to 100
    @State private var countdown: Int = 0 // Start from 0

    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                // Background Image
                Image("welcome")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    Spacer()
                    // Countdown Text
                    Text("\(countdown)%") // Display countdown percentage
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 10) // Adjust spacing above the progress bar

                    // Progress Bar
                    ProgressView(value: progress, total: 100.0) // Progress bar from 0 to 100
                        .progressViewStyle(LinearProgressViewStyle(tint: .black)) // Black progress bar
                        .frame(width: 300) // Set width of the progress bar
                        .padding(.horizontal, 40)

                    Spacer()
                }
            }
            .onAppear {
                // Start a timer to update the progress and countdown
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                    withAnimation {
                        progress += 1.0 // Increment progress by 1% every 0.1 seconds
                        countdown += 1 // Increment countdown from 0 to 100
                    }
                    if progress >= 100.0 {
                        timer.invalidate() // Stop the timer when progress reaches 100%
                        isActive = true // Switch to ContentView
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}


