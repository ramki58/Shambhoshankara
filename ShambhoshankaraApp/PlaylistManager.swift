import Foundation

struct UserPlaylist: Identifiable, Codable {
    let id = UUID()
    var name: String
    var trackIds: [String]
    var createdDate: Date
    var color: String // For visual distinction
}

class PlaylistManager: ObservableObject {
    @Published var playlists: [UserPlaylist] = []
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadPlaylists()
        createDefaultPlaylists()
    }
    
    func createPlaylist(name: String, color: String = "orange") -> UserPlaylist {
        let playlist = UserPlaylist(name: name, trackIds: [], createdDate: Date(), color: color)
        playlists.append(playlist)
        savePlaylists()
        return playlist
    }
    
    func addTrackToPlaylist(_ track: AudioTrack, playlist: UserPlaylist) {
        print("=== ADDING TRACK TO PLAYLIST ===")
        print("Track: \(track.title)")
        print("Playlist: \(playlist.name)")
        print("Track fileName: \(track.fileName)")
        print("Playlist ID: \(playlist.id)")
        
        if let index = playlists.firstIndex(where: { $0.id == playlist.id }) {
            print("Found playlist at index \(index)")
            let trackIdentifier = track.fileName
            print("Using trackIdentifier: \(trackIdentifier)")
            print("Current trackIds before: \(playlists[index].trackIds)")
            
            if !playlists[index].trackIds.contains(trackIdentifier) {
                playlists[index].trackIds.append(trackIdentifier)
                savePlaylists()
                print("✅ Track added successfully!")
                print("Playlist now has \(playlists[index].trackIds.count) tracks")
                print("Current trackIds after: \(playlists[index].trackIds)")
            } else {
                print("❌ Track already in playlist")
            }
        } else {
            print("❌ Playlist not found")
        }
        print("=== END ADDING TRACK ===")
    }
    
    func removeTrackFromPlaylist(_ trackFileName: String, playlist: UserPlaylist) {
        if let index = playlists.firstIndex(where: { $0.id == playlist.id }) {
            playlists[index].trackIds.removeAll { $0 == trackFileName }
            savePlaylists()
        }
    }
    
    func deletePlaylist(_ playlist: UserPlaylist) {
        playlists.removeAll { $0.id == playlist.id }
        savePlaylists()
    }
    
    func getTracksForPlaylist(_ playlist: UserPlaylist) -> [AudioTrack] {
        let audioDataManager = AudioDataManager.shared
        var allTracks: [AudioTrack] = []
        
        // Collect all tracks from all categories
        allTracks.append(contentsOf: audioDataManager.getSlokamTracks())
        allTracks.append(contentsOf: audioDataManager.getSandhyaVandhanamTracks())
        allTracks.append(contentsOf: audioDataManager.getMahanyasamTracks())
        allTracks.append(contentsOf: audioDataManager.getSriRudramTracks())
        allTracks.append(contentsOf: audioDataManager.getPanchaSookthams())
        allTracks.append(contentsOf: audioDataManager.getHomamTracks())
        
        // Filter tracks that are in this playlist using fileName
        return allTracks.filter { track in
            playlist.trackIds.contains(track.fileName)
        }
    }
    
    private func createDefaultPlaylists() {
        if playlists.isEmpty {
            // Create learning-focused default playlists
            let beginnerPlaylist = createPlaylist(name: "🌱 Beginner Practice", color: "green")
            let dailyPlaylist = createPlaylist(name: "📅 Daily Recitation", color: "blue")
            let favoritePlaylist = createPlaylist(name: "⭐ Favorites", color: "yellow")
        }
    }
    
    private func savePlaylists() {
        if let encoded = try? JSONEncoder().encode(playlists) {
            userDefaults.set(encoded, forKey: "playlists")
        }
    }
    
    private func loadPlaylists() {
        if let data = userDefaults.data(forKey: "playlists"),
           let decoded = try? JSONDecoder().decode([UserPlaylist].self, from: data) {
            playlists = decoded
        }
    }
}