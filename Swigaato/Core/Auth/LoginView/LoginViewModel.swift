import Foundation
import Firebase
import FirebaseAuth
import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isSuccess = false
    @Published var navigateToHome = false
    
    func login(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return
        }
        
        Task {
            do {
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                self.alertMessage = "Login successful!"
                self.isSuccess = true
                self.showAlert = true
                
                // Delay navigation slightly to allow alert to be shown
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigateToHome = true
                }
            } catch {
                self.alertMessage = error.localizedDescription
                self.showAlert = true
            }
        }
    }
} 