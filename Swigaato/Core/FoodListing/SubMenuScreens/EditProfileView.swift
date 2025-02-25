//
//  EditProfileView.swift
//  Swigaato
//
//  Created by Tech Exactly iPhone 6 on 03/02/25.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = "Ohid iOS Dev"
    @State private var email = "ohid@example.com"
    @State private var phone = "+1 234 567 8900"
    @State private var address = "123 Main St, New York"
    @State private var showImagePicker = false
    @State private var profileImage: UIImage?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HeaderView(title: "Edit Profile", dismiss: dismiss)
                
                // Profile Image Section
                Button(action: { showImagePicker = true }) {
                    VStack {
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.blue)
                        }
                        
                        Text("Change Photo")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                
                // Form Fields
                VStack(spacing: 20) {
                    EditField(title: "Full Name", text: $name, icon: "person.fill")
                    EditField(title: "Email", text: $email, icon: "envelope.fill")
                    EditField(title: "Phone", text: $phone, icon: "phone.fill")
                    EditField(title: "Address", text: $address, icon: "location.fill")
                }
                .padding()
                
                // Save Button
                Button(action: saveChanges) {
                    Text("Save Changes")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showImagePicker) {
            // Image picker implementation
            Text("Image Picker")
        }
    }
    
    private func saveChanges() {
        // Implement save functionality
        dismiss()
    }
}

private struct EditField: View {
    let title: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.gray)
                .font(.caption)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                TextField(title, text: $text)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.2), radius: 5)
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
