import Foundation

struct ChatMessage: Identifiable, Codable {
    var id: String = UUID().uuidString
    let isUser: Bool
    let text: String
    var timestamp: Date = Date()
}

class ChatSessionManager: ObservableObject {
    @Published var messages: [ChatMessage] = []
    
    private let defaults = UserDefaults.standard
    private let historyKey = "qwen3chat_history"
    
    init() {
        // No history loading on start for fresh chat
    }
    
    func addMessage(text: String, isUser: Bool) {
        let msg = ChatMessage(isUser: isUser, text: text)
        messages.append(msg)
    }
    
    func buildPrompt(maxCharacters: Int = 3000) -> String {
        var validMessages: [ChatMessage] = []
        var currentLength = 0
        
        // Loop from the newest message to oldest to safely fit within max window
        for msg in messages.reversed() {
            let role = msg.isUser ? "User" : "Assistant"
            let line = "\(role): \(msg.text)"
            
            // If adding this message exceeds the max character limit (roughly max tokens), we drop older ones
            if currentLength + line.count > maxCharacters {
                break
            }
            
            validMessages.insert(msg, at: 0)
            currentLength += line.count
        }
        
        let historyPrompt = validMessages.map { msg in
            let role = msg.isUser ? "User" : "Assistant"
            return "\(role): \(msg.text)"
        }.joined(separator: "\n")
        
        return historyPrompt + "\nAssistant: "
    }
    
    func clearHistory() {
        messages.removeAll()
        saveHistory()
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(messages) {
            defaults.set(encoded, forKey: historyKey)
        }
    }
    
    private func loadHistory() {
        if let data = defaults.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([ChatMessage].self, from: data) {
            messages = decoded
        }
    }
}
