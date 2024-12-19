
import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUserProfile() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        let uid = authDataResult.uid
        self.user = try await UserManager.shared.getUser(uid: uid)
    }
}
