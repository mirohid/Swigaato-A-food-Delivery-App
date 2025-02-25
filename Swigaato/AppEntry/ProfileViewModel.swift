import SwiftUI
import Firebase
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserModel?
    @Published var addresses: [AddressModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    
    private let db = Firestore.firestore()
    
    func fetchUserProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.errorMessage = "No user is signed in"
            self.showAlert = true
            return
        }
        
        isLoading = true
        
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            self.isLoading = false
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showAlert = true
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "User data not found"
                self.showAlert = true
                return
            }
            
            let fullName = data["full_name"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            let uid = data["uid"] as? String ?? ""
            
            self.userProfile = UserModel(fullName: fullName, email: email, uid: uid)
            
            // After fetching user profile, fetch addresses
            self.fetchUserAddresses()
        }
    }
    
    func fetchUserAddresses() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("addresses")
            .whereField("user_id", isEqualTo: userId)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                self.addresses = documents.compactMap { document in
                    let data = document.data()
                    
                    return AddressModel(
                        id: document.documentID,
                        userId: data["user_id"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        street: data["street"] as? String ?? "",
                        city: data["city"] as? String ?? "",
                        state: data["state"] as? String ?? "",
                        zipCode: data["zip_code"] as? String ?? "",
                        isDefault: data["is_default"] as? Bool ?? false
                    )
                }
            }
    }
    
    func addAddress(name: String, street: String, city: String, state: String, zipCode: String, isDefault: Bool) {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.errorMessage = "User not logged in"
            self.showAlert = true
            return
        }
        
        let addressData: [String: Any] = [
            "user_id": userId,
            "name": name,
            "street": street,
            "city": city,
            "state": state,
            "zip_code": zipCode,
            "is_default": isDefault
        ]
        
        // If this is set as default, update all other addresses to non-default
        if isDefault {
            updateDefaultAddresses(userId: userId) { [weak self] success in
                guard let self = self, success else { return }
                
                // Now add the new default address
                self.db.collection("addresses").addDocument(data: addressData) { error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        return
                    }
                    
                    self.fetchUserAddresses() // Refresh addresses
                }
            }
        } else {
            // Just add the address without changing defaults
            db.collection("addresses").addDocument(data: addressData) { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    return
                }
                
                self.fetchUserAddresses() // Refresh addresses
            }
        }
    }
    
    private func updateDefaultAddresses(userId: String, completion: @escaping (Bool) -> Void) {
        // Get all addresses for this user
        db.collection("addresses")
            .whereField("user_id", isEqualTo: userId)
            .whereField("is_default", isEqualTo: true)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { 
                    completion(false)
                    return 
                }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    completion(false)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(true) // No default addresses found
                    return
                }
                
                let batch = self.db.batch()
                
                // Update all existing default addresses to non-default
                for document in documents {
                    let docRef = self.db.collection("addresses").document(document.documentID)
                    batch.updateData(["is_default": false], forDocument: docRef)
                }
                
                // Commit the batch update
                batch.commit { error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                        completion(false)
                        return
                    }
                    
                    completion(true)
                }
            }
    }
    
    func deleteAddress(id: String) {
        db.collection("addresses").document(id).delete { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showAlert = true
                return
            }
            
            self.fetchUserAddresses() // Refresh addresses
        }
    }
}
