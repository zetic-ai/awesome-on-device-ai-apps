import SwiftUI
import SwiftData
import UIKit

/// Home screen — "Brew". Date-grouped list, search, recording FAB, the
/// bottom "Ask anything" bar, and a mini recording bar while capture continues.
struct NotesListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Note.createdAt, order: .reverse) private var notes: [Note]

    @StateObject private var recording = RecordingViewModel()
    @ObservedObject private var llm = LLMService.shared
    @State private var isRecordingActive = false
    @State private var showRecordingSheet = false
    @State private var showAskAnything = false
    @State private var path: [Note] = []
    @State private var search = ""
    @State private var showSearch = false
    @State private var showSettings = false
    @State private var noteToDelete: Note?
    @FocusState private var searchFocused: Bool

    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottom) {
                Theme.canvas.ignoresSafeArea()
                content
                bottomControls
            }
            .navigationBarHidden(true)
            .navigationDestination(for: Note.self) { note in
                NoteDetailView(note: note)
            }
        }
        .tint(Theme.ink)
        .task {
            // Rescue any work interrupted by a crash mid-meeting, then start
            // downloading/initializing the on-device model in the background so
            // it's ready by the time a note is recorded.
            await TranscriptionWorker.shared.recoverInterruptedWork(context: context)
            await LLMService.shared.ensureLoaded()
        }
        .confirmationDialog(
            "Delete this note?",
            isPresented: Binding(
                get: { noteToDelete != nil },
                set: { if !$0 { noteToDelete = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let note = noteToDelete { delete(note) }
                noteToDelete = nil
            }
        } message: {
            Text("The note, transcript, chat, and audio recording will be permanently deleted.")
        }
        .sheet(isPresented: $showRecordingSheet) {
            RecordingSheet(
                vm: recording,
                onCancel: {
                    recording.cancel()
                    isRecordingActive = false
                    showRecordingSheet = false
                },
                onStop: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    isRecordingActive = false
                    showRecordingSheet = false
                    let note = recording.stopAndSave(context: context)
                    path.append(note)
                }
            )
        }
        .sheet(isPresented: $showAskAnything) {
            AskAnythingView(notes: notes)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .alert("Permission needed", isPresented: $recording.permissionDenied) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Enable Microphone and Speech Recognition in Settings to record meetings.")
        }
    }

    // MARK: - Content

    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                if showSearch && groupedSections.isEmpty {
                    Text(notes.isEmpty ? "No notes yet." : "No notes match your search.")
                        .font(.system(size: 16))
                        .foregroundStyle(Theme.inkSecondary)
                        .padding(.top, 8)
                }
                ForEach(groupedSections, id: \.title) { section in
                    sectionView(section)
                }
                Color.clear.frame(height: 160) // room for bottom controls
            }
            .padding(.horizontal, 20)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                ModelStatusChip()
                Spacer()
                HStack(spacing: 4) {
                    CircleIconButton(systemName: "magnifyingglass") {
                        withAnimation(.snappy) {
                            showSearch.toggle()
                            if showSearch {
                                searchFocused = true
                            } else {
                                search = ""
                            }
                        }
                    }
                    Button {
                        showSettings = true
                    } label: {
                        Circle().fill(Color(hex: 0xD9CEF2))
                            .frame(width: 46, height: 46)
                            .overlay(Text("B").font(Theme.serif(20, weight: .semibold)).foregroundStyle(Theme.ink))
                    }
                    .buttonStyle(.plain)
                }
            }
            (Text("Your ") + Text("Private").italic() + Text(" Notes"))
                .font(Theme.serif(37, weight: .regular))
                .foregroundStyle(Theme.ink)
            if showSearch {
                searchField
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 24)
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15))
                .foregroundStyle(Theme.inkSecondary)
            TextField("Search notes", text: $search)
                .font(.system(size: 16))
                .focused($searchFocused)
                .submitLabel(.search)
            if !search.isEmpty {
                Button {
                    search = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Theme.inkTertiary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(Theme.cardElevated)
        .clipShape(Capsule())
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    private func sectionView(_ section: NoteSection) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.title)
                .font(.system(size: 16))
                .foregroundStyle(Theme.inkSecondary)
            ForEach(section.notes) { note in
                Button {
                    path.append(note)
                } label: {
                    NoteCard(note: note)
                }
                .buttonStyle(.plain)
                .contextMenu {
                    Button(role: .destructive) {
                        noteToDelete = note
                    } label: {
                        Label("Delete note", systemImage: "trash")
                    }
                }
            }
        }
        .padding(.bottom, 24)
    }

    // MARK: - Bottom controls

    private var bottomControls: some View {
        VStack(spacing: 0) {
            if isRecordingActive && !showRecordingSheet {
                RecordingMiniBar(
                    title: "New note",
                    elapsed: recording.elapsed,
                    level: recording.level,
                    onTap: { showRecordingSheet = true }
                )
            } else {
                HStack(spacing: 12) {
                    askAnythingPill
                    fab
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
        }
    }

    private var askAnythingPill: some View {
        Button {
            showAskAnything = true
        } label: {
            HStack {
                Text("Ask anything")
                    .font(.system(size: 17))
                    .foregroundStyle(Theme.inkSecondary)
                Spacer()
                Image(systemName: "mic")
                    .foregroundStyle(Theme.inkSecondary)
                    .frame(width: 38, height: 38)
                    .background(Theme.card)
                    .clipShape(Circle())
            }
            .padding(.leading, 20)
            .padding(.trailing, 6)
            .padding(.vertical, 6)
            .background(Theme.cardElevated)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.06), radius: 10, y: 3)
        }
        .buttonStyle(.plain)
    }

    private var fab: some View {
        // A meeting can't be started until the on-device model has finished
        // preparing. A load failure doesn't block capture — recording and
        // transcription don't need the model; the AI note is generated later.
        let ready = llm.preparationResolved
        return Button {
            guard ready else { return }
            Task {
                if await recording.start() {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    isRecordingActive = true
                    showRecordingSheet = true
                }
            }
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 26, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
                .background(Theme.accent)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.18), radius: 10, y: 4)
        }
        .buttonStyle(.plain)
        .disabled(!ready)
        .opacity(ready ? 1 : 0.45)
        .animation(.easeInOut(duration: 0.2), value: ready)
    }

    // MARK: - Deletion

    private func delete(_ note: Note) {
        if let name = note.audioFileName {
            try? FileManager.default.removeItem(
                at: TranscriptionWorker.documentsURL.appendingPathComponent(name)
            )
        }
        path.removeAll { $0 == note }
        context.delete(note)
        try? context.save()
    }

    // MARK: - Grouping

    private var filteredNotes: [Note] {
        let q = search.trimmingCharacters(in: .whitespaces).lowercased()
        guard !q.isEmpty else { return notes }
        return notes.filter {
            $0.displayTitle.lowercased().contains(q) || $0.transcript.lowercased().contains(q)
        }
    }

    struct NoteSection { let title: String; let notes: [Note] }

    private var groupedSections: [NoteSection] {
        let cal = Calendar.current
        let grouped = Dictionary(grouping: filteredNotes) { note -> Date in
            cal.startOfDay(for: note.createdAt)
        }
        return grouped.keys.sorted(by: >).map { day in
            NoteSection(title: label(for: day), notes: grouped[day] ?? [])
        }
    }

    private func label(for day: Date) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(day) { return "Today" }
        if cal.isDateInYesterday(day) { return "Yesterday" }
        let f = DateFormatter()
        f.dateFormat = cal.isDate(day, equalTo: .now, toGranularity: .year) ? "EEE d MMM" : "EEE d MMM yyyy"
        return f.string(from: day)
    }
}
