import SwiftUI

struct LevelBasedCategoryView: View {
    let category: String
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var playlistManager: PlaylistManager
    @State private var selectedLevel = 1
    
    var body: some View {
        VStack(spacing: 0) {
            // Compact category header
            HStack(spacing: 12) {
                Text(getCategoryIcon())
                    .font(.system(size: 24))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(category)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(getCategoryDescription())
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                // Quick playlist access button
                QuickPlaylistButton()
                    .environmentObject(playlistManager)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            
            // Level tabs with better visibility
            HStack(spacing: 0) {
                ForEach(getLevelsForCategory(), id: \.self) { level in
                    Button(action: {
                        selectedLevel = level
                    }) {
                        VStack(spacing: 3) {
                            Text("Level \(level)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(selectedLevel == level ? .white : Color.black.opacity(0.8))
                            
                            Rectangle()
                                .fill(selectedLevel == level ? .white : Color.clear)
                                .frame(height: 2)
                        }
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedLevel == level ? 
                            getCategoryColors()[0] : 
                            Color.white.opacity(0.9)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.white.opacity(0.95))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
            .overlay(
                Rectangle()
                    .fill(Color.black.opacity(0.1))
                    .frame(height: 1),
                alignment: .bottom
            )
            
            // Content for selected level
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        // Current track player with Om symbol (only when playing)
                        if let track = audioManager.currentTrack {
                            CurrentTrackCard(track: track)
                                .environmentObject(audioManager)
                                .id("nowPlaying")
                        }
                        
                        // Synchronized text for Sri Rudram (show only when playing Sri Rudram)
                        if category == "Sri Rudram",
                           let currentTrack = audioManager.currentTrack,
                           currentTrack.fileName.contains("Rudra") {
                            SynchronizedTextView(track: currentTrack)
                                .environmentObject(audioManager)
                                .padding(.horizontal, 20)
                        }
                        
                        // Now Playing highlight card (appears below player)
                        if let currentTrack = audioManager.currentTrack,
                           getTracksForLevel(selectedLevel).contains(where: { $0.id == currentTrack.id }) {
                            NowPlayingHighlightCard(track: currentTrack)
                                .environmentObject(audioManager)
                                .id("highlight")
                        }
                        
                        // Tracks for selected level
                        LazyVStack(spacing: 16) {
                            ForEach(getTracksForLevel(selectedLevel)) { track in
                                ModernTrackRowView(track: track)
                                    .environmentObject(audioManager)
                                    .environmentObject(playlistManager)
                                    .id(track.id)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
                .onChange(of: audioManager.currentTrack) { newTrack in
                    if let track = newTrack,
                       getTracksForLevel(selectedLevel).contains(where: { $0.id == track.id }) {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            proxy.scrollTo("highlight", anchor: .top)
                        }
                    }
                }
            }
        }
        .background(
            LinearGradient(
                colors: getCategoryColors(),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .onAppear {
            // Set initial level to first available level
            if let firstLevel = getLevelsForCategory().first {
                selectedLevel = firstLevel
            }
        }
    }
    
    private func getCategoryColors() -> [Color] {
        switch category {
        case "Slokams":
            return [Color(red: 0.9, green: 0.7, blue: 0.5), Color(red: 0.8, green: 0.5, blue: 0.3)]
        case "Sandhya Vandhanam":
            return [Color(red: 1.0, green: 0.8, blue: 0.4), Color(red: 0.9, green: 0.6, blue: 0.2)]
        case "Mahanyasam":
            return [Color(red: 0.8, green: 0.6, blue: 0.9), Color(red: 0.6, green: 0.4, blue: 0.7)]
        case "Sri Rudram":
            return [Color(red: 0.9, green: 0.4, blue: 0.3), Color(red: 0.7, green: 0.2, blue: 0.1)]
        case "Pancha Sookthams":
            return [Color(red: 0.4, green: 0.8, blue: 0.6), Color(red: 0.2, green: 0.6, blue: 0.4)]
        case "Homam":
            return [Color(red: 0.9, green: 0.5, blue: 0.2), Color(red: 0.8, green: 0.3, blue: 0.1)]
        default:
            return [Color(red: 0.9, green: 0.7, blue: 0.5), Color(red: 0.8, green: 0.5, blue: 0.3)]
        }
    }
    
    private func getCategoryIcon() -> String {
        switch category {
        case "Slokams": return "📿"
        case "Sandhya Vandhanam": return "🌅"
        case "Mahanyasam": return "🙏"
        case "Sri Rudram": return "🔥"
        case "Pancha Sookthams": return "⭐"
        case "Homam": return "🕯"
        default: return "🕉"
        }
    }
    
    private func getCategoryDescription() -> String {
        switch category {
        case "Slokams": return "Sacred verses and devotional chants"
        case "Sandhya Vandhanam": return "Daily prayer rituals"
        case "Mahanyasam": return "Sacred ritual of divine invocation"
        case "Sri Rudram": return "Powerful hymns to Lord Shiva"
        case "Pancha Sookthams": return "Five sacred hymns from the Vedas"
        case "Homam": return "Fire ritual procedures and mantras"
        default: return "Sacred audio collection"
        }
    }
    
    private func getLevelsForCategory() -> [Int] {
        switch category {
        case "Slokams":
            return [1, 2, 3, 4]
        case "Sandhya Vandhanam":
            return [1, 2, 3, 4]
        case "Mahanyasam":
            return [1, 2, 3, 4]
        case "Sri Rudram":
            return [1, 2, 3, 4]
        case "Pancha Sookthams":
            return [3, 4] // Only levels 3 and 4 available
        case "Homam":
            return [3, 4] // Only levels 3 and 4 available
        default:
            return [1]
        }
    }
    
    private func getTracksForLevel(_ level: Int) -> [AudioTrack] {
        let allTracks = getCategoryTracks()
        return allTracks.filter { track in
            let title = track.title.lowercased()
            return title.contains("level-\(level)") || title.contains("level \(level)")
        }
    }
    
    private func getCategoryTracks() -> [AudioTrack] {
        switch category {
        case "Slokams":
            return AudioDataManager.shared.getSlokamTracks()
        case "Sandhya Vandhanam":
            return AudioDataManager.shared.getSandhyaVandhanamTracks()
        case "Mahanyasam":
            return AudioDataManager.shared.getMahanyasamTracks()
        case "Sri Rudram":
            return AudioDataManager.shared.getSriRudramTracks()
        case "Pancha Sookthams":
            return AudioDataManager.shared.getPanchaSookthams()
        case "Homam":
            return AudioDataManager.shared.getHomamTracks()
        default:
            return []
        }
    }
}

#Preview {
    LevelBasedCategoryView(category: "Slokams")
        .environmentObject(AudioManager())
}