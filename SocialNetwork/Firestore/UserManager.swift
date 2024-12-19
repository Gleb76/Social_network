
import Foundation
import FirebaseFirestore

struct DBUser: Codable {
    let userId: String
    let email: String?
    let displayName: String?
    let photoUrl: String?
    let dateCreated: Date?
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String: Any] = [
            "user_id": auth.uid,
            "date_created": Timestamp(),
        ]
        
        if let email = auth.email {
            userData["email"] = email
        }
        
        if let displayName = auth.username {
            userData["display_name"] = displayName
        }
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData)
    }
    
    func getUser(uid: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        
        guard let data = snapshot.data() else {
            throw URLError(.badServerResponse)
        }
        
        guard let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let email = data["email"] as? String
        let displayName = data["display_name"] as? String
        let photoUrl = data["photo_url"] as? String
        let dateCreated = (data["date_created"] as? Timestamp)?.dateValue()
        
        return DBUser(userId: userId, email: email, displayName: displayName, photoUrl: photoUrl, dateCreated: dateCreated)
    }
}

