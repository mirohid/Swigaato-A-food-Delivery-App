//
//  AppSettingsView.swift
//  Swigaato
//
//  Created by Tech Exactly iPhone 6 on 03/02/25.
//

import SwiftUI

struct AppSettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isDarkMode = false
    @State private var notificationsEnabled = true
    @State private var emailNotifications = true
    @State private var pushNotifications = true
    @State private var language = "English"
    @State private var currency = "USD"
    
    private let languages = ["English", "Spanish", "French", "German"]
    private let currencies = ["USD", "EUR", "GBP", "JPY"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .imageScale(.large)
                    }
                    Spacer()
                    Text("Settings")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                
                // Settings Groups
                VStack(spacing: 25) {
                    // Appearance Settings
                    SettingsGroup(title: "Appearance") {
                        Toggle("Dark Mode", isOn: $isDarkMode)
                        
                        Picker("Language", selection: $language) {
                            ForEach(languages, id: \.self) { language in
                                Text(language).tag(language)
                            }
                        }
                        
                        Picker("Currency", selection: $currency) {
                            ForEach(currencies, id: \.self) { currency in
                                Text(currency).tag(currency)
                            }
                        }
                    }
                    
                    // Notification Settings
                    SettingsGroup(title: "Notifications") {
                        Toggle("Enable Notifications", isOn: $notificationsEnabled)
                        if notificationsEnabled {
                            Toggle("Email Notifications", isOn: $emailNotifications)
                            Toggle("Push Notifications", isOn: $pushNotifications)
                        }
                    }
                    
                    // Privacy Settings
                    SettingsGroup(title: "Privacy") {
                        NavigationLink("Privacy Policy") {
                            Text("Privacy Policy Content")
                        }
                        NavigationLink("Terms of Service") {
                            Text("Terms of Service Content")
                        }
                    }
                    
                    // About Section
                    SettingsGroup(title: "About") {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.gray)
                        }
                        
                        Button("Check for Updates") {
                            // Handle update check
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }
}

private struct SettingsGroup<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 2) {
                content
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.2), radius: 5)
        }
    }
}

struct AppSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingsView()
    }
}
