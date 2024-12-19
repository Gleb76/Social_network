import SwiftUI
import FirebaseAuth

@MainActor
final class UserViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var uid: String = ""
    @Published var email: String = ""
    @Published var photoUrl: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isSignedIn: Bool = false
    
    // MARK: - Initialization
    init() {
        Task {
            await fetchCurrentUser()
        }
    }
    
    // MARK: - Fetch Current User
    func fetchCurrentUser() async {
        clearError()
        isLoading = true
        defer { isLoading = false }
        
        do {
            let user = try AuthenticationManager.shared.getAuthenticatedUser()
            updateUser(with: user)
            isSignedIn = true
        } catch {
            handleError(error)
            isSignedIn = false
        }
    }
    
    // MARK: - Update Profile
    func updateProfile(email: String? = nil, photoUrl: String? = nil) async {
        clearError()
        isLoading = true
        defer { isLoading = false }
        
        do {
            if let email = email {
                try await Auth.auth().currentUser?.updateEmail(to: email)
                self.email = email
            }
            if let photoUrl = photoUrl {
                let photoUrlObject = URL(string: photoUrl)
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                request?.photoURL = photoUrlObject
                try await request?.commitChanges()
                self.photoUrl = photoUrl
            }
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        clearError()
        do {
            try AuthenticationManager.shared.signOut()
            clearUser()
            isSignedIn = false
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Helpers
    private func updateUser(with user: AuthDataResultModel) {
        self.uid = user.uid
        self.email = user.email ?? ""
        self.photoUrl = user.photoUrl ?? ""
    }
    
    private func clearUser() {
        self.uid = ""
        self.email = ""
        self.photoUrl = ""
    }
    
    private func clearError() {
        errorMessage = nil
    }
    
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
    }
}
