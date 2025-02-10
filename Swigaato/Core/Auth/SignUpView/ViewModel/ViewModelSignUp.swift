//
//  ViewModel.swift
//  Swigaato
//
//  Created by MacMini6 on 07/02/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignUpViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isSuccess = false
    @Published var navigateToHome = false
    
    func signUp(name: String, email: String, password: String, confirmPassword: String) {
        // Validate inputs
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Passwords don't match"
            showAlert = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.alertMessage = error.localizedDescription
                self.showAlert = true
                return
            }
            
            guard let user = result?.user else { return }
            
            // Create user document in Firestore
            let db = Firestore.firestore()
            let userData = [
                "full_name": name,
                "email": email,
                "uid": user.uid
            ]
            
            db.collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                    return
                }
                
                self.alertMessage = "Account created successfully!"
                self.isSuccess = true
                self.showAlert = true
                self.navigateToHome = true
            }
        }
    }
} 
