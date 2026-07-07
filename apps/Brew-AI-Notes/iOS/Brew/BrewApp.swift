import SwiftUI
import SwiftData

@main
struct BrewApp: App {
    var body: some Scene {
        WindowGroup {
            NotesListView()
                // The palette is a fixed light/paper design (cream canvas, dark
                // ink). Without locking the scheme, dark mode flips system-default
                // colors — navigation titles and TextField input — to white, where
                // they vanish on the cream background.
                .preferredColorScheme(.light)
        }
        .modelContainer(for: [Note.self, ChatMessage.self])
    }
}
