import SwiftUI

struct CategoryView: View {
    let category: String
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        NavigationView {
            ZStack {
                // Category-specific gradient background
                LinearGradient(
                    colors: getCategoryColors(),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Floating particles when playing
                if audioManager.isPlaying {
                    FloatingParticlesView()
                        .ignoresSafeArea()
                        .opacity(0.3)
                }
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Category header
                        VStack(spacing: 12) {
                            Text(getCategoryIcon())
                                .font(.system(size: 50))
                            
                            Text(category)
                                .font(.largeTitle)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text(getCategoryDescription())
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 20)
                        
                        // Current track player (if playing)
                        if let track = audioManager.currentTrack {
                            CurrentTrackCard(track: track)
                                .environmentObject(audioManager)
                        }
                        
                        // Category content
                        if category == "Sri Rudram" {
                            // Level-based view for Sri Rudram
                            SriRudramView()
                                .environmentObject(audioManager)
                        } else if category == "Mahanyasam" {
                            // Hierarchical view for Mahanyasam
                            LazyVStack(spacing: 16) {
                                ForEach(getMahanyasamSections(), id: \.title) { section in
                                    RudramSectionView(section: section)
                                        .environmentObject(audioManager)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                        } else {
                            // Regular tracks for other categories
                            LazyVStack(spacing: 16) {
                                ForEach(getCategoryTracks()) { track in
                                    ModernTrackRowView(track: track)
                                        .environmentObject(audioManager)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
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
        case "Sandhya Vandhanam": return "Daily prayer rituals for morning, noon & evening"
        case "Mahanyasam": return "Sacred ritual of divine invocation"
        case "Sri Rudram": return "Powerful hymns to Lord Shiva"
        case "Pancha Sookthams": return "Five sacred hymns from the Vedas"
        case "Homam": return "Fire ritual procedures and mantras"
        default: return "Sacred audio collection"
        }
    }
    
    private func getCategoryTracks() -> [AudioTrack] {
        switch category {
        case "Slokams":
            return AudioDataManager.shared.getSlokamTracks()
        case "Sandhya Vandhanam":
            return AudioDataManager.shared.getSandhyaVandhanamTracks()
        case "Pancha Sookthams":
            return AudioDataManager.shared.getPanchaSookthams()
        case "Homam":
            return AudioDataManager.shared.getHomamTracks()
        default:
            return []
        }
    }
    

    
    private func getMahanyasamSections() -> [RudramSection] {
        return AudioDataManager.shared.getMahanyasamSections()
    }
}

struct CurrentTrackCard: View {
    let track: AudioTrack
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        VStack(spacing: 15) {
            // Mini album art
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.9), Color.white.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 120)
                .overlay(
                    Text("🕉")
                        .font(.system(size: 40))
                        .rotationEffect(.degrees(audioManager.isPlaying ? 360 : 0))
                        .animation(
                            Animation.linear(duration: 8)
                                .repeatForever(autoreverses: false),
                            value: audioManager.isPlaying
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            // Track info
            VStack(spacing: 8) {
                Text(track.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Now Playing")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Mini controls
            HStack(spacing: 30) {
                Button(action: audioManager.togglePlayPause) {
                    Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                
                Button(action: audioManager.stop) {
                    Image(systemName: "stop.circle")
                        .font(.system(size: 30))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            // Time display
            HStack {
                Text(audioManager.formatTime(audioManager.currentTime))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Text(audioManager.formatTime(audioManager.duration))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Mini progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 4)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white)
                        .frame(
                            width: geometry.size.width * (audioManager.duration > 0 ? audioManager.currentTime / audioManager.duration : 0),
                            height: 4
                        )
                }
            }
            .frame(height: 4)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.2))
                .blur(radius: 10)
        )
        .padding(.horizontal, 20)
    }
}

struct RudramSection {
    let title: String
    let tracks: [AudioTrack]
}

struct RudramSectionView: View {
    let section: RudramSection
    @State private var isExpanded = false
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        VStack(spacing: 0) {
            // Section header
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text("🔥")
                        .font(.title3)
                    
                    Text(section.title)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Color(red: 0.6, green: 0.1, blue: 0.2))
                    
                    Spacer()
                    
                    Text("\(section.tracks.count) verses")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.6, green: 0.1, blue: 0.2).opacity(0.8))
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color(red: 0.6, green: 0.1, blue: 0.2))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.4), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Expandable tracks
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(section.tracks) { track in
                        RudramTrackRowView(track: track)
                            .environmentObject(audioManager)
                    }
                }
                .padding(.top, 8)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .top)),
                    removal: .opacity.combined(with: .move(edge: .top))
                ))
            }
        }
    }
}

struct RudramTrackRowView: View {
    let track: AudioTrack
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        Button(action: {
            audioManager.play(track: track)
        }) {
            HStack(spacing: 12) {
                // Rudram specific icon
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
                    .frame(width: 45, height: 45)
                    .overlay(
                        Text("🔥")
                            .font(.title3)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(track.title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                        .lineLimit(2)
                    
                    Text("Sri Rudram")
                        .font(.system(size: 13))
                        .foregroundColor(Color(red: 0.5, green: 0.3, blue: 0.2).opacity(0.8))
                }
                
                Spacer()
                
                if audioManager.currentTrack?.id == track.id {
                    Image(systemName: audioManager.isPlaying ? "speaker.wave.2.fill" : "speaker.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                } else {
                    Image(systemName: "play.circle")
                        .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1).opacity(0.7))
                        .font(.title3)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.9, green: 0.4, blue: 0.3).opacity(0.2),
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
    CategoryView(category: "Slokams")
        .environmentObject(AudioManager())
}