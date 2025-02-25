import SwiftUI
import Firebase

struct ProfileManagementView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var isShowingAddressForm = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Button {
                        dismiss()
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
                    
                    Text("Profile Management")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 50)
                
                // Profile Information Section
                if let userProfile = viewModel.userProfile {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Profile Information")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .foregroundColor(.gray)
                                Text(userProfile.fullName)
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.gray)
                                Text(userProfile.email)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5)
                        .padding(.horizontal)
                    }
                    .padding(.top)
                } else if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    Text("Profile information not available")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }
                
                // Addresses Section
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Delivery Addresses")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button(action: {
                            isShowingAddressForm = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add New")
                            }
                            .foregroundColor(.black)
                            .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)
                    
                    if viewModel.addresses.isEmpty {
                        Text("No saved addresses")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        ForEach(viewModel.addresses) { address in
                            AddressCard(address: address, onDelete: { viewModel.deleteAddress(id: address.id) })
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
                
                Button(action: {
                    // Sign out
                    do {
                        try Auth.auth().signOut()
                        // Navigate back or to login
                        dismiss()
                    } catch {
                        viewModel.errorMessage = "Error signing out"
                        viewModel.showAlert = true
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.right.square.fill")
                        Text("Sign Out")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.top, 30)
            }
            .padding(.bottom, 50)
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.gray.opacity(0.1))
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isShowingAddressForm) {
            AddAddressView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.fetchUserProfile()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct AddressCard: View {
    let address: AddressModel
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(address.name)
                    .font(.headline)
                
                Spacer()
                
                if address.isDefault {
                    Text("Default")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .cornerRadius(5)
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.red)
                }
            }
            
            Text(address.street)
                .font(.subheadline)
            
            Text("\(address.city), \(address.state) \(address.zipCode)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
}

struct AddAddressView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    
    @State private var name: String = ""
    @State private var street: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zipCode: String = ""
    @State private var isDefault: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Address Details")) {
                    TextField("Full Name", text: $name)
                    TextField("Street Address", text: $street)
                    TextField("City", text: $city)
                    TextField("State", text: $state)
                    TextField("ZIP Code", text: $zipCode)
                }
                
                Section {
                    Toggle("Set as Default Address", isOn: $isDefault)
                }
                
                Button(action: saveAddress) {
                    Text("Save Address")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(formIsValid ? Color.black : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!formIsValid)
                .padding()
            }
            .navigationTitle("Add New Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    var formIsValid: Bool {
        !name.isEmpty && !street.isEmpty && !city.isEmpty && !state.isEmpty && !zipCode.isEmpty
    }
    
    func saveAddress() {
        viewModel.addAddress(
            name: name,
            street: street,
            city: city,
            state: state,
            zipCode: zipCode,
            isDefault: isDefault
        )
        dismiss()
    }
}

struct ProfileManagementView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileManagementView()
    }
}
