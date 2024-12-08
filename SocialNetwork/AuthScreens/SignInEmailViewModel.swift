import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Sign Up Function
    func signUp() async {
        clearError()
        guard validateInput() else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await AuthenticationManager.shared.createUser(email: email, password: password)
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Sign In Function
    func signIn() async {
        clearError()
        guard validateInput() else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await AuthenticationManager.shared.signInUser(email: email, password: password)
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Helpers
    private func validateInput() -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty."
            return false
        }
        guard isValidEmail(email) else {
            errorMessage = "Invalid email format."
            return false
        }
        return true
    }
    
    private func clearError() {
        errorMessage = nil
    }
    
    private func handleError(_ error: Error) {
        // Customize error handling based on Firebase error codes if needed
        errorMessage = error.localizedDescription
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
