import SwiftUI

@main
struct Qwen3Chat_iOSApp: App {
    @StateObject private var llmService = LLMService()
    @StateObject private var sessionManager = ChatSessionManager()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(llmService)
                .environmentObject(sessionManager)
                .preferredColorScheme(.dark)
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
            
            DiagnosticsView()
                .tabItem {
                    Label("Diagnostics", systemImage: "cpu")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
