import SwiftUI

struct PlaylistTracksView: View {
    let playlist: UserPlaylist
    @EnvironmentObject var playlistManager: PlaylistManager
    @EnvironmentObject var audioManager: AudioManager
    @Environment(\.dismiss) private var dismiss
    
    private var tracks: [AudioTrack] {
        playlistManager.getTracksForPlaylist(playlist)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Text(getPlaylistIcon(playlist.color))
                        .font(.system(size: 50))
                    
                    Text(playlist.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("\(tracks.count) tracks")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                // Tracks List
                if tracks.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Text("🎵")
                            .font(.system(size: 60))
                        
                        Text("No tracks in this playlist")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("Add tracks from any category to build your playlist")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(tracks) { track in
                                PlaylistTrackRow(track: track, playlist: playlist)
                                    .environmentObject(audioManager)
                                    .environmentObject(playlistManager)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
            .background(
                LinearGradient(
                    colors: [getPlaylistColor(playlist.color), getPlaylistColor(playlist.color).opacity(0.7)],
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
        }
    }
    
    private func getPlaylistIcon(_ color: String) -> String {
        switch color {
        case "green": return "🌱"
        case "blue": return "📅"
        case "yellow": return "⭐"
        case "red": return "🔥"
        case "purple": return "🙏"
        default: return "🎵"
        }
    }
    
    private func getPlaylistColor(_ colorName: String) -> Color {
        switch colorName {
        case "green": return .green
        case "blue": return .blue
        case "yellow": return .yellow
        case "red": return .red
        case "purple": return .purple
        default: return .orange
        }
    }
}

struct PlaylistTrackRow: View {
    let track: AudioTrack
    let playlist: UserPlaylist
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var playlistManager: PlaylistManager
    
    var body: some View {
        HStack(spacing: 12) {
            // Play button
            Button(action: {
                audioManager.play(track: track)
            }) {
                Image(systemName: audioManager.currentTrack?.id == track.id && audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            // Track info
            VStack(alignment: .leading, spacing: 4) {
                Text(track.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(track.artist)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            // Remove from playlist button
            Button(action: {
                playlistManager.removeTrackFromPlaylist(track.fileName, playlist: playlist)
            }) {
                Image(systemName: "minus.circle")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    let samplePlaylist = UserPlaylist(name: "Sample Playlist", trackIds: [], createdDate: Date(), color: "orange")
    return PlaylistTracksView(playlist: samplePlaylist)
        .environmentObject(PlaylistManager())
        .environmentObject(AudioManager())
}