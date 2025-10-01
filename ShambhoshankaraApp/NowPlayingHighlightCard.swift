import SwiftUI

struct NowPlayingHighlightCard: View {
    let track: AudioTrack
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("🎵 Now Playing")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.green)
                    )
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                // Animated icon
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.green.opacity(0.8),
                                Color.blue.opacity(0.6)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text("🕉")
                            .font(.title2)
                            .rotationEffect(.degrees(audioManager.isPlaying ? 360 : 0))
                            .animation(
                                Animation.linear(duration: 4)
                                    .repeatForever(autoreverses: false),
                                value: audioManager.isPlaying
                            )
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(track.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    HStack {
                        Text(track.artist)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                        
                        if track.duration > 0 {
                            Text("• \(audioManager.formatTime(track.duration))")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: audioManager.isPlaying ? "speaker.wave.3.fill" : "speaker.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                        .scaleEffect(audioManager.isPlaying ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: audioManager.isPlaying)
                    
                    Text("LIVE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            
            // Mini progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 3)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .frame(
                            width: geometry.size.width * (audioManager.duration > 0 ? audioManager.currentTime / audioManager.duration : 0),
                            height: 3
                        )
                }
            }
            .frame(height: 3)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.green.opacity(0.3),
                            Color.blue.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                )
        )
        .padding(.horizontal, 20)
        .scaleEffect(audioManager.isPlaying ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: audioManager.isPlaying)
    }
}

#Preview {
    let sampleTrack = AudioTrack(id: UUID(), title: "Sample Track", artist: "Artist", duration: 180, fileName: "test.mp3")
    return NowPlayingHighlightCard(track: sampleTrack)
        .environmentObject(AudioManager())
        .padding()
        .background(Color.blue)
}