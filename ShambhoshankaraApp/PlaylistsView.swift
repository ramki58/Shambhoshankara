import SwiftUI

struct PlaylistsView: View {
    @EnvironmentObject var playlistManager: PlaylistManager
    @EnvironmentObject var audioManager: AudioManager
    @State private var showingCreatePlaylist = false
    @State private var newPlaylistName = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 16) {
                        Text("🎵")
                            .font(.system(size: 50))
                        
                        Text("My Playlists")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Create custom playlists for focused practice")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Create New Playlist Button
                    Button(action: {
                        showingCreatePlaylist = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                            Text("Create New Playlist")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                                )
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Playlists Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(playlistManager.playlists) { playlist in
                            PlaylistCard(playlist: playlist)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .background(
                LinearGradient(
                    colors: [Color(red: 0.4, green: 0.8, blue: 0.6), Color(red: 0.2, green: 0.6, blue: 0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingCreatePlaylist) {
            CreatePlaylistSheet(
                playlistName: $newPlaylistName,
                isPresented: $showingCreatePlaylist
            )
        }
    }
}

struct PlaylistCard: View {
    let playlist: UserPlaylist
    @EnvironmentObject var playlistManager: PlaylistManager
    @EnvironmentObject var audioManager: AudioManager
    @State private var showingPlaylistTracks = false
    
    var body: some View {
        Button(action: {
            showingPlaylistTracks = true
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(getPlaylistIcon(playlist.color))
                        .font(.title2)
                    
                    Spacer()
                    
                    Menu {
                        Button("Edit", action: {})
                        Button("Delete", role: .destructive) {
                            playlistManager.deletePlaylist(playlist)
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                Text(playlist.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text("\(playlist.trackIds.count) tracks")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Created \(formatDate(playlist.createdDate))")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(16)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingPlaylistTracks) {
            PlaylistTracksView(playlist: playlist)
                .environmentObject(playlistManager)
                .environmentObject(audioManager)
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
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct CreatePlaylistSheet: View {
    @Binding var playlistName: String
    @Binding var isPresented: Bool
    @EnvironmentObject var playlistManager: PlaylistManager
    @State private var selectedColor = "orange"
    
    let colors = ["orange", "green", "blue", "yellow", "red", "purple"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Create New Playlist")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Playlist Name")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Enter playlist name...", text: $playlistName)
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text("Choose Color")
                        .font(.headline)
                    
                    HStack {
                        ForEach(colors, id: \.self) { color in
                            Button(action: {
                                selectedColor = color
                            }) {
                                Circle()
                                    .fill(getColor(color))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: selectedColor == color ? 3 : 0)
                                    )
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Small delay to ensure the sheet is fully presented
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    // Focus will be automatic with the new text field style
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                        playlistName = ""
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        if !playlistName.isEmpty {
                            playlistManager.createPlaylist(name: playlistName, color: selectedColor)
                            isPresented = false
                            playlistName = ""
                        }
                    }
                    .disabled(playlistName.isEmpty)
                }
            }
        }
    }
    
    private func getColor(_ colorName: String) -> Color {
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

#Preview {
    PlaylistsView()
        .environmentObject(PlaylistManager())
        .environmentObject(AudioManager())
}