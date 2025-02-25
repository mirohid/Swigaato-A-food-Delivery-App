//
//  NotificationSettingsView.swift
//  Swigaato
//
//  Created by Tech Exactly iPhone 6 on 03/02/25.
//

import SwiftUI

struct NotificationSettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var pushEnabled = true
    @State private var emailEnabled = true
    @State private var orderUpdates = true
    @State private var promotions = false
    @State private var newDeals = true
    @State private var soundEnabled = true
    @State private var vibrationEnabled = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HeaderView(title: "Notifications", dismiss: dismiss)
                
                VStack(spacing: 25) {
                    // General Settings
                    NotificationGroup(title: "General") {
                        ToggleRow(title: "Push Notifications", isOn: $pushEnabled)
                        ToggleRow(title: "Email Notifications", isOn: $emailEnabled)
                    }
                    
                    // Notification Types
                    NotificationGroup(title: "Notification Types") {
                        ToggleRow(title: "Order Updates", isOn: $orderUpdates)
                        ToggleRow(title: "Promotions", isOn: $promotions)
                        ToggleRow(title: "New Deals", isOn: $newDeals)
                    }
                    
                    // Sound & Vibration
                    NotificationGroup(title: "Sound & Vibration") {
                        ToggleRow(title: "Sound", isOn: $soundEnabled)
                        ToggleRow(title: "Vibration", isOn: $vibrationEnabled)
                    }
                    
                    // Quiet Hours
                    NotificationGroup(title: "Quiet Hours") {
                        NavigationLink(destination: QuietHoursView()) {
                            HStack {
                                Text("Set Quiet Hours")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }
}

private struct NotificationGroup<Content: View>: View {
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

private struct ToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(title, isOn: $isOn)
            .padding(.vertical, 4)
    }
}

private struct QuietHoursView: View {
    @State private var quietHoursEnabled = false
    @State private var startTime = Date()
    @State private var endTime = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            Toggle("Enable Quiet Hours", isOn: $quietHoursEnabled)
            
            if quietHoursEnabled {
                DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
            }
        }
        .padding()
        .navigationTitle("Quiet Hours")
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}
