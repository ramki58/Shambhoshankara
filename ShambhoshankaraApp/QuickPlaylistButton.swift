import SwiftUI

struct QuickPlaylistButton: View {
    @EnvironmentObject var playlistManager: PlaylistManager
    @State private var showingPlaylists = false
    
    var body: some View {
        Button(action: {
            showingPlaylists = true
        }) {
            Image(systemName: "music.note.list")
                .font(.title3)
                .foregroundColor(.white)
                .padding(8)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.4), lineWidth: 1)
                        )
                )
        }
        .sheet(isPresented: $showingPlaylists) {
            PlaylistsView()
                .environmentObject(playlistManager)
        }
    }
}

#Preview {
    QuickPlaylistButton()
        .environmentObject(PlaylistManager())
}