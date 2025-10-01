import SwiftUI

struct SriRudramView: View {
    @EnvironmentObject var audioManager: AudioManager
    @State private var selectedLevel = 1
    
    var body: some View {
        VStack(spacing: 0) {
            // Level tabs at top
            HStack(spacing: 0) {
                ForEach(1...4, id: \.self) { level in
                    Button(action: {
                        selectedLevel = level
                    }) {
                        VStack(spacing: 4) {
                            Text("Level \(level)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(selectedLevel == level ? .white : Color(red: 0.6, green: 0.1, blue: 0.2))
                            
                            Rectangle()
                                .fill(selectedLevel == level ? .white : Color.clear)
                                .frame(height: 2)
                        }
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedLevel == level ? 
                            Color(red: 0.6, green: 0.1, blue: 0.2) : 
                            Color.white.opacity(0.1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .background(Color.white.opacity(0.05))
            
            // Content for selected level
            ScrollView {
                VStack(spacing: 20) {
                    // Current track player (if playing)
                    if let track = audioManager.currentTrack {
                        CurrentTrackCard(track: track)
                            .environmentObject(audioManager)
                    }
                    
                    // Tracks for selected level
                    LazyVStack(spacing: 16) {
                        ForEach(getTracksForLevel(selectedLevel)) { track in
                            SriRudramTrackRowView(track: track)
                                .environmentObject(audioManager)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
    }
    
    private func getTracksForLevel(_ level: Int) -> [AudioTrack] {
        switch level {
        case 1:
            return [
                AudioTrack(id: UUID(), title: "Namakam 1", artist: "Sri Rudram", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-1.mp3"),
                AudioTrack(id: UUID(), title: "Namakam 2", artist: "Sri Rudram", duration: 0, fileName: "https://shambhoshankara.com/Audio/Pranodevi-1.mp3"),
                AudioTrack(id: UUID(), title: "Chamakam 1", artist: "Sri Rudram", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gurubrahma-1.mp3")
            ]
        case 2:
            return [
                AudioTrack(id: UUID(), title: "Namakam 1", artist: "Sri Rudram", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-2.mp3"),
                AudioTrack(id: UUID(), title: "Namakam 2", artist: "Sri Rudram", duration: 0, fileName: "https://shambhoshankara.com/Audio/Pranodevi-2.mp3"),
                AudioTrack(id: UUID(), title: "Chamakam 1", artist: "Sri Rudram", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gurubrahma-2.mp3")
            ]
        case 3:
            return [
                AudioTrack(id: UUID(), title: "Namakam 1", artist: "Sri Rudram", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-3.mp3"),
                AudioTrack(id: UUID(), title: "Namakam 2", artist: "Sri Rudram", duration: 0, fileName: "https://shambhoshankara.com/Audio/Pranodevi-3.mp3"),
                AudioTrack(id: UUID(), title: "Chamakam 1", artist: "Sri Rudram", duration: 0, fileName: "https://shambhoshankara.com/Audio/RudraSankalpam_P00_L2.mp3")
            ]
        case 4:
            return [
                AudioTrack(id: UUID(), title: "Namakam 1", artist: "Sri Rudram", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-4.mp3"),
                AudioTrack(id: UUID(), title: "Namakam 2", artist: "Sri Rudram", duration: 0, fileName: "https://shambhoshankara.com/Audio/Pranodevi-4.mp3"),
                AudioTrack(id: UUID(), title: "Chamakam 1", artist: "Sri Rudram", duration: 0, fileName: "https://shambhoshankara.com/Audio/GanapathiPujaL3.mp3")
            ]
        default:
            return []
        }
    }
}

struct SriRudramTrackRowView: View {
    let track: AudioTrack
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        Button(action: {
            audioManager.play(track: track)
        }) {
            HStack(spacing: 12) {
                // Sri Rudram specific icon
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.9, green: 0.3, blue: 0.2),
                                Color(red: 0.8, green: 0.2, blue: 0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text("🔥")
                            .font(.title2)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(track.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                        .lineLimit(2)
                    
                    Text("Sri Rudram")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.5, green: 0.3, blue: 0.2).opacity(0.8))
                }
                
                Spacer()
                
                if audioManager.currentTrack?.id == track.id {
                    VStack {
                        Image(systemName: audioManager.isPlaying ? "speaker.wave.2.fill" : "speaker.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                        
                        Text("Playing")
                            .font(.caption2)
                            .foregroundColor(.red)
                    }
                } else {
                    Image(systemName: "play.circle")
                        .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1).opacity(0.7))
                        .font(.title2)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.9, green: 0.4, blue: 0.3).opacity(0.15),
                                Color(red: 0.8, green: 0.3, blue: 0.2).opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 1.0, green: 0.5, blue: 0.3).opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SriRudramView()
        .environmentObject(AudioManager())
}