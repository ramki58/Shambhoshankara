import SwiftUI

struct EnhancedAudioPlayerView: View {
    let track: AudioTrack
    @EnvironmentObject var audioManager: AudioManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingText = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 4) {
                    // Ultra Compact Player
                    VStack(spacing: 2) {
                        // Title and Controls in one row
                        HStack {
                            Text(track.title)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            // Play/Pause Button
                            Button(action: {
                                if audioManager.currentTrack?.fileName == track.fileName {
                                    audioManager.togglePlayPause()
                                } else {
                                    audioManager.play(track: track)
                                }
                            }) {
                                Image(systemName: audioManager.isPlaying && audioManager.currentTrack?.fileName == track.fileName ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Progress Bar
                        VStack(spacing: 2) {
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 1)
                                        .fill(Color.white.opacity(0.3))
                                        .frame(height: 2)
                                    
                                    RoundedRectangle(cornerRadius: 1)
                                        .fill(Color.white)
                                        .frame(
                                            width: audioManager.duration > 0 ? 
                                                geometry.size.width * (audioManager.currentTime / audioManager.duration) : 0,
                                            height: 2
                                        )
                                }
                            }
                            .frame(height: 2)
                            
                            HStack {
                                Text(audioManager.formatTime(audioManager.currentTime))
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Spacer()
                                
                                Text(audioManager.formatTime(audioManager.duration))
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white.opacity(0.1))
                    )
                    
                    // Synchronized Text Display (always show)
                    SynchronizedTextView(track: track)
                        .environmentObject(audioManager)
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 8)
            }
            .background(
                LinearGradient(
                    colors: [Color(red: 0.9, green: 0.4, blue: 0.3), Color(red: 0.7, green: 0.2, blue: 0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .onAppear {
                print("🎵 EnhancedAudioPlayerView onAppear - auto-starting audio")
                // Auto-start the audio when enhanced player opens
                if audioManager.currentTrack?.fileName != track.fileName || !audioManager.isPlaying {
                    audioManager.play(track: track)
                }
            }
        }
    }
}

#Preview {
    let sampleTrack = AudioTrack(
        id: UUID(),
        title: "Namakam Lesson 1 - Level 1",
        artist: "Sri Rudram",
        duration: 180,
        fileName: "RudraNamakam_P01_L1.mp3"
    )
    
    return EnhancedAudioPlayerView(track: sampleTrack)
        .environmentObject(AudioManager())
}