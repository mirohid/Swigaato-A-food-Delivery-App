import Foundation
import Firebase
import FirebaseAuth

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
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.alertMessage = error.localizedDescription
                self.showAlert = true
                return
            }
            
            self.alertMessage = "Login successful!"
            self.isSuccess = true
            self.showAlert = true
            self.navigateToHome = true
        }
    }
} 