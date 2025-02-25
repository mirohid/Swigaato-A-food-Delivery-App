//
//  ProfileView.swift
//  Swigaato
//
//  Created by Tech Exactly iPhone 6 on 03/02/25.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    // Sample user data
    private let userData = UserProfile(
        name: "Ohid iOS Dev",
        email: "ohid@example.com",
        phone: "+1 234 567 8900",
        address: "123 Main St, New York",
        profileImage: "person.circle.fill"
    )
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with back button
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .imageScale(.large)
                    }
                    Spacer()
                    Text("Profile")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                
                // Profile Image
                Image(systemName: userData.profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
                
                // User Info Cards
                VStack(spacing: 15) {
                    InfoCard(title: "Name", value: userData.name, icon: "person.fill")
                    InfoCard(title: "Email", value: userData.email, icon: "envelope.fill")
                    InfoCard(title: "Phone", value: userData.phone, icon: "phone.fill")
                    InfoCard(title: "Address", value: userData.address, icon: "location.fill")
                }
                .padding()
                
                // Stats Section
                HStack(spacing: 20) {
                    StatCard(title: "Orders", value: "28", icon: "bag.fill")
                    StatCard(title: "Reviews", value: "12", icon: "star.fill")
                    StatCard(title: "Points", value: "360", icon: "gift.fill")
                }
                .padding()
                
                // Action Buttons
                VStack(spacing: 15) {
                    ActionButton(title: "Edit Profile", icon: "pencil") {
                        // Handle edit profile
                    }
                    ActionButton(title: "My Orders", icon: "clock.fill") {
                        // Handle orders
                    }
                    ActionButton(title: "Settings", icon: "gear") {
                        // Handle settings
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }
}

// Supporting Views
private struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.gray)
                    .font(.caption)
                Text(value)
                    .font(.body)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5)
    }
}

private struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title2)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 5)
    }
}

private struct ActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .foregroundColor(.primary)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.2), radius: 5)
        }
    }
}

// Model
private struct UserProfile {
    let name: String
    let email: String
    let phone: String
    let address: String
    let profileImage: String
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
