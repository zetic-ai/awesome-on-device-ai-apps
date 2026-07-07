import SwiftUI

/// The "New Note" recording sheet: title, live transcript, level meter, and
/// pause / cancel controls (matches reference screenshot 3).
struct RecordingSheet: View {
    @ObservedObject var vm: RecordingViewModel
    var onCancel: () -> Void
    var onStop: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            Theme.canvas.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Label(vm.language.displayName, systemImage: "globe")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.inkSecondary)
                    Spacer()
                    Menu {
                        Picker("Audio language", selection: $vm.language) {
                            ForEach(TranscriptionLanguage.allCases) { lang in
                                Text(lang.displayName).tag(lang)
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Theme.ink)
                            .frame(width: 44, height: 44)
                            .background(Theme.card)
                            .clipShape(Circle())
                    }
                }

                Text("New Note")
                    .font(Theme.serif(38, weight: .regular))
                    .foregroundStyle(Theme.inkSecondary)

                HStack(spacing: 8) {
                    Image(systemName: vm.recordingHealthy ? "waveform" : "exclamationmark.triangle.fill")
                        .foregroundStyle(vm.recordingHealthy ? Theme.iconTileInk : .orange)
                    Text(statusText)
                        .font(.system(size: 16))
                        .foregroundStyle(vm.recordingHealthy ? Theme.inkSecondary : .orange)
                }
                .padding(.top, 4)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)

            controls
        }
        .presentationDragIndicator(.visible)
    }

    private var statusText: String {
        if !vm.recordingHealthy {
            return "Recording problem — audio may not be saving. Try stopping and starting a new recording."
        }
        return vm.isPaused
            ? "Paused"
            : "Recording… everything you say will be transcribed when you stop."
    }

    private var controls: some View {
        HStack {
            Button {
                vm.isPaused ? vm.resume() : vm.pause()
            } label: {
                Image(systemName: vm.isPaused ? "play.fill" : "pause.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Theme.ink)
                    .frame(width: 84, height: 56)
                    .background(Theme.cardElevated)
                    .clipShape(Capsule())
            }

            Spacer()

            HStack(spacing: 8) {
                Text(timeString(vm.elapsed))
                    .font(.system(size: 18, weight: .semibold).monospacedDigit())
                    .foregroundStyle(Theme.ink)
                LevelBars(level: vm.isPaused ? 0 : vm.level)
            }

            Spacer()

            Button(action: onStop) {
                Text("Stop")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Theme.ink)
                    .frame(width: 84, height: 56)
                    .background(Theme.cardElevated)
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
        .overlay(alignment: .topTrailing) {
            Button("Cancel", action: onCancel)
                .font(.system(size: 15))
                .foregroundStyle(Theme.inkSecondary)
                .padding(.trailing, 24)
                .offset(y: -28)
        }
    }

}
