import Foundation
import SwiftData

enum ChatRole: String, Codable {
    case user
    case assistant
}

@Model
final class ChatMessage {
    @Attribute(.unique) var id: UUID
    var roleRaw: String
    var content: String
    var createdAt: Date
    var note: Note?

    init(id: UUID = UUID(), role: ChatRole, content: String, createdAt: Date = .now, note: Note? = nil) {
        self.id = id
        self.roleRaw = role.rawValue
        self.content = content
        self.createdAt = createdAt
        self.note = note
    }

    var role: ChatRole {
        get { ChatRole(rawValue: roleRaw) ?? .user }
        set { roleRaw = newValue.rawValue }
    }
}
