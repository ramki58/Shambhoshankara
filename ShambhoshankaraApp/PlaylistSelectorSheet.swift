import SwiftUI

struct PlaylistSelectorSheet: View {
    let track: AudioTrack
    @EnvironmentObject var playlistManager: PlaylistManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("🎵")
                        .font(.system(size: 40))
                    
                    Text("Manage Playlist")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(track.title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding(.top)
                .onAppear {
                    print("PlaylistSelectorSheet appeared with \(playlistManager.playlists.count) playlists")
                }
                
                // Playlists list
                if playlistManager.playlists.isEmpty {
                    VStack(spacing: 16) {
                        Text("📝")
                            .font(.system(size: 50))
                        
                        Text("No playlists yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Create your first playlist to organize your favorite tracks")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(playlistManager.playlists, id: \.id) { playlist in
                                PlaylistRowButton(playlist: playlist, track: track)
                                    .environmentObject(playlistManager)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PlaylistRowButton: View {
    let playlist: UserPlaylist
    let track: AudioTrack
    @EnvironmentObject var playlistManager: PlaylistManager
    @Environment(\.dismiss) private var dismiss
    @State private var justAdded = false
    
    private var isTrackInPlaylist: Bool {
        playlist.trackIds.contains(track.fileName)
    }
    
    var body: some View {
        Button(action: {
            print("=== PLAYLIST BUTTON TAPPED ===")
            print("Playlist: \(playlist.name)")
            print("Track: \(track.title)")
            print("Track fileName: \(track.fileName)")
            print("Track in playlist: \(isTrackInPlaylist)")
            print("Current playlist trackIds: \(playlist.trackIds)")
            
            if isTrackInPlaylist {
                playlistManager.removeTrackFromPlaylist(track.fileName, playlist: playlist)
                print("Track removed from playlist")
            } else {
                playlistManager.addTrackToPlaylist(track, playlist: playlist)
                print("Track added to playlist")
                // Show visual feedback
                withAnimation(.easeInOut(duration: 0.3)) {
                    justAdded = true
                }
                // Reset after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    justAdded = false
                }
            }
        }) {
            HStack(spacing: 12) {
                // Playlist icon
                RoundedRectangle(cornerRadius: 8)
                    .fill(getPlaylistColor(playlist.color))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(getPlaylistIcon(playlist.color))
                            .font(.title3)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(playlist.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text("\(playlist.trackIds.count) tracks")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Add/Remove indicator with animation
                HStack(spacing: 4) {
                    Image(systemName: isTrackInPlaylist ? "checkmark.circle.fill" : "plus.circle")
                        .foregroundColor(isTrackInPlaylist ? .green : .blue)
                        .font(.title2)
                        .scaleEffect(justAdded ? 1.3 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: justAdded)
                    
                    if isTrackInPlaylist {
                        Text("Remove")
                            .font(.caption)
                            .foregroundColor(.green)
                    } else {
                        Text("Add")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isTrackInPlaylist ? Color.green : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
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
}

#Preview {
    let sampleTrack = AudioTrack(id: UUID(), title: "Sample Track", artist: "Artist", duration: 180, fileName: "test.mp3")
    return PlaylistSelectorSheet(track: sampleTrack)
        .environmentObject(PlaylistManager())
}