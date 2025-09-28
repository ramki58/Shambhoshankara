import SwiftUI

struct PlaylistView: View {
    @EnvironmentObject var audioManager: AudioManager
    @State private var showingCreatePlaylist = false
    @State private var newPlaylistName = ""
    @State private var selectedTracks: Set<UUID> = []
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color.purple.opacity(0.2),
                        Color.orange.opacity(0.1),
                        Color.blue.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    // Header
                    HStack {
                        Text("🎵 Playlists")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.purple, .orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Spacer()
                        
                        Button(action: {
                            showingCreatePlaylist = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.orange)
                        }
                    }
                    .padding()
                    
                    // Playlists list
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(audioManager.playlists) { playlist in
                                PlaylistCardView(playlist: playlist)
                                    .environmentObject(audioManager)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingCreatePlaylist) {
                CreatePlaylistView(
                    playlistName: $newPlaylistName,
                    selectedTracks: $selectedTracks,
                    isPresented: $showingCreatePlaylist
                )
                .environmentObject(audioManager)
            }
        }
    }
}

struct PlaylistCardView: View {
    let playlist: Playlist
    @EnvironmentObject var audioManager: AudioManager
    @State private var showingTracks = false
    
    var body: some View {
        Button(action: {
            showingTracks = true
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    // Playlist icon
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [.purple.opacity(0.6), .orange.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "music.note.list")
                                .font(.title2)
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(playlist.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("\(playlist.tracks.count) tracks")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if let firstTrack = playlist.tracks.first {
                            audioManager.play(track: firstTrack)
                        }
                    }) {
                        Image(systemName: "play.circle.fill")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Track preview
                if !playlist.tracks.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(playlist.tracks.prefix(3)) { track in
                            HStack {
                                Image(systemName: "music.note")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                
                                Text(track.title)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                
                                Spacer()
                            }
                        }
                        
                        if playlist.tracks.count > 3 {
                            Text("and \(playlist.tracks.count - 3) more...")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .padding(.leading, 16)
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingTracks) {
            PlaylistDetailView(playlist: playlist)
                .environmentObject(audioManager)
        }
    }
}

struct PlaylistDetailView: View {
    let playlist: Playlist
    @EnvironmentObject var audioManager: AudioManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [.purple.opacity(0.1), .orange.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    // Playlist header
                    VStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [.purple.opacity(0.6), .orange.opacity(0.4)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "music.note.list")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            )
                        
                        Text(playlist.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("\(playlist.tracks.count) tracks")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Play all button
                    Button(action: {
                        if let firstTrack = playlist.tracks.first {
                            audioManager.play(track: firstTrack)
                        }
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Play All")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.orange, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                    }
                    
                    // Tracks list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(playlist.tracks) { track in
                                TrackRowView(track: track)
                                    .environmentObject(audioManager)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle(playlist.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
}

struct CreatePlaylistView: View {
    @Binding var playlistName: String
    @Binding var selectedTracks: Set<UUID>
    @Binding var isPresented: Bool
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Playlist Name", text: $playlistName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Text("Select Tracks")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(audioManager.playlist) { track in
                            HStack {
                                Button(action: {
                                    if selectedTracks.contains(track.id) {
                                        selectedTracks.remove(track.id)
                                    } else {
                                        selectedTracks.insert(track.id)
                                    }
                                }) {
                                    Image(systemName: selectedTracks.contains(track.id) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(.orange)
                                }
                                
                                TrackRowView(track: track)
                                    .environmentObject(audioManager)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("New Playlist")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                    playlistName = ""
                    selectedTracks.removeAll()
                },
                trailing: Button("Create") {
                    let tracksToAdd = audioManager.playlist.filter { selectedTracks.contains($0.id) }
                    audioManager.createPlaylist(name: playlistName, tracks: tracksToAdd)
                    isPresented = false
                    playlistName = ""
                    selectedTracks.removeAll()
                }
                .disabled(playlistName.isEmpty || selectedTracks.isEmpty)
            )
        }
    }
}

#Preview {
    PlaylistView()
        .environmentObject(AudioManager())
}