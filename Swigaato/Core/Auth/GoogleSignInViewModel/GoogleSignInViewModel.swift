import SwiftUI
import Firebase
import GoogleSignIn

class GoogleSignInViewModel: ObservableObject {
    @Published var user: GIDGoogleUser?

    func signIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("❌ Firebase Client ID not found")
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            print("❌ RootViewController not found")
            return
        }

        print("ℹ️ Starting Google Sign-In")
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("❌ Google Sign-In error: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                print("❌ Google User or ID Token not found")
                return
            }

            print("✅ Google Sign-In successful: \(user.profile?.name ?? "No Name")")

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("❌ Firebase Sign-In error: \(error.localizedDescription)")
                } else {
                    self.user = user
                    print("✅ Firebase Sign-In successful as \(user.profile?.email ?? "No Email")")
                }
            }
        }
    }
}
