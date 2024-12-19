
import Foundation

struct Contact: Identifiable {
    let id = UUID()
    let name: String
    let lastSeen: String
    let profileImage: String?
    let stories: Bool
    let isOnline: Bool
}
