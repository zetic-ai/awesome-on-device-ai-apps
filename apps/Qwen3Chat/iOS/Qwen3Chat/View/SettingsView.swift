import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var sessionManager: ChatSessionManager
    @State private var showingClearAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(role: .destructive, action: {
                        showingClearAlert = true
                    }) {
                        HStack {
                            Text("Clear Chat History")
                            Spacer()
                            Image(systemName: "trash")
                        }
                    }
                    .alert("Clear History", isPresented: $showingClearAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Clear", role: .destructive) {
                            sessionManager.clearHistory()
                        }
                    } message: {
                        Text("Are you sure you want to clear all messages? This cannot be undone.")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
