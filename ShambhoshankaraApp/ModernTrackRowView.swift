import SwiftUI

struct ModernTrackRowView: View {
    let track: AudioTrack
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var playlistManager: PlaylistManager
    @State private var showingPlaylistSelector = false {
        didSet {
            print("PlaylistSelector sheet state changed to: \(showingPlaylistSelector)")
        }
    }
    @State private var showingEnhancedPlayer = false
    
    private var isCurrentTrack: Bool {
        audioManager.currentTrack?.id == track.id
    }
    
    var body: some View {
        Button(action: {
            audioManager.play(track: track)
        }) {
            HStack(spacing: 12) {
                // Track icon with dynamic colors
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: isCurrentTrack ? [
                                Color.green.opacity(0.9),
                                Color.blue.opacity(0.7)
                            ] : [
                                Color.white.opacity(0.9),
                                Color.white.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(isCurrentTrack ? "🕉" : "🎵")
                            .font(.title2)
                            .rotationEffect(.degrees(isCurrentTrack && audioManager.isPlaying ? 360 : 0))
                            .animation(
                                Animation.linear(duration: 3)
                                    .repeatForever(autoreverses: false),
                                value: isCurrentTrack && audioManager.isPlaying
                            )
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(track.title)
                        .font(.system(size: 16, weight: isCurrentTrack ? .bold : .medium))
                        .foregroundColor(isCurrentTrack ? .black : .white)
                        .lineLimit(2)
                    
                    HStack {
                        Text(track.artist)
                            .font(.system(size: 14, weight: isCurrentTrack ? .medium : .regular))
                            .foregroundColor(isCurrentTrack ? .black.opacity(0.8) : .white.opacity(0.8))
                        
                        if track.duration > 0 {
                            Text("• \(audioManager.formatTime(track.duration))")
                                .font(.system(size: 12))
                                .foregroundColor(isCurrentTrack ? .black.opacity(0.7) : .white.opacity(0.6))
                        }
                    }
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    // Learn button (for Sri Rudram tracks)
                    if track.fileName.contains("Rudra") {
                        Button(action: {
                            print("📖 Learn button tapped for: \(track.title)")
                            showingEnhancedPlayer = true
                        }) {
                            Image(systemName: "book.circle.fill")
                                .foregroundColor(.white)
                                .font(.title3)
                                .background(
                                    Circle()
                                        .fill(Color.green.opacity(0.8))
                                        .frame(width: 32, height: 32)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Add to Playlist button
                    Button(action: {
                        showingPlaylistSelector = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.white)
                            .font(.title3)
                            .background(
                                Circle()
                                    .fill(Color.blue.opacity(0.8))
                                    .frame(width: 32, height: 32)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onTapGesture {
                        showingPlaylistSelector = true
                    }
                    
                    if isCurrentTrack {
                        VStack {
                            Image(systemName: audioManager.isPlaying ? "speaker.wave.3.fill" : "speaker.fill")
                                .foregroundColor(.black)
                                .font(.title2)
                                .scaleEffect(audioManager.isPlaying ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: audioManager.isPlaying)
                            
                            Text(audioManager.isPlaying ? "PLAYING" : "PAUSED")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    } else {
                        Image(systemName: "play.circle")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.title2)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isCurrentTrack ? 
                        LinearGradient(
                            colors: [
                                Color.yellow,      // Bright yellow
                                Color.orange,      // Orange
                                Color.red          // Red
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isCurrentTrack ? Color.white.opacity(0.8) : Color.white.opacity(0.3), 
                                lineWidth: isCurrentTrack ? 3 : 1
                            )
                    )
                    .shadow(
                        color: isCurrentTrack ? Color.green.opacity(0.5) : Color.clear,
                        radius: isCurrentTrack ? 8 : 0,
                        x: 0,
                        y: isCurrentTrack ? 4 : 0
                    )
            )
            .scaleEffect(isCurrentTrack ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isCurrentTrack)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingPlaylistSelector) {
            PlaylistSelectorSheet(track: track)
                .environmentObject(playlistManager)
                .interactiveDismissDisabled(false)
        }
        .sheet(isPresented: $showingEnhancedPlayer) {
            EnhancedAudioPlayerView(track: track)
                .environmentObject(audioManager)
                .onAppear {
                    print("📖 EnhancedAudioPlayerView appeared for: \(track.title)")
                }
        }
    }
}

#Preview {
    let sampleTrack = AudioTrack(id: UUID(), title: "Sample Track", artist: "Artist", duration: 180, fileName: "test.mp3")
    return ModernTrackRowView(track: sampleTrack)
        .environmentObject(AudioManager())
        .padding()
        .background(Color.blue)
}