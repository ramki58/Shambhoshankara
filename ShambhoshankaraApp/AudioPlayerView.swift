import SwiftUI

struct AudioPlayerView: View {
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        NavigationView {
            ZStack {
                // Modern gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.85, blue: 0.7),  // Warm cream
                        Color(red: 0.9, green: 0.7, blue: 0.5),   // Soft saffron
                        Color(red: 0.8, green: 0.4, blue: 0.2)    // Deep orange
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Floating particles when playing
                if audioManager.isPlaying {
                    FloatingParticlesView()
                        .ignoresSafeArea()
                        .opacity(0.4)
                }
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Modern header
                        VStack(spacing: 8) {
                            Text("🕉")
                                .font(.system(size: 40))
                            Text("Shambhoshankara")
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                    
                        // Current track card
                        if let track = audioManager.currentTrack {
                            VStack(spacing: 20) {
                                // Animated album art with visualizer
                                ZStack {
                                    // Pulsing background rings
                                    if audioManager.isPlaying {
                                        ForEach(0..<3, id: \.self) { i in
                                            Circle()
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [Color.yellow.opacity(0.6), Color.orange.opacity(0.3)],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 3
                                                )
                                                .frame(width: 300 + CGFloat(i * 40), height: 300 + CGFloat(i * 40))
                                                .scaleEffect(audioManager.isPlaying ? 1.2 : 1.0)
                                                .opacity(audioManager.isPlaying ? 0.3 : 0.8)
                                                .animation(
                                                    Animation.easeInOut(duration: 2.0 + Double(i) * 0.5)
                                                        .repeatForever(autoreverses: true)
                                                        .delay(Double(i) * 0.3),
                                                    value: audioManager.isPlaying
                                                )
                                        }
                                    }
                                    
                                    // Main album art
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.9),
                                                    Color(red: 1.0, green: 0.8, blue: 0.4).opacity(0.8)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 280, height: 280)
                                        .overlay(
                                            ZStack {
                                                // Rotating Om symbol
                                                Text("🕉")
                                                    .font(.system(size: 60))
                                                    .rotationEffect(.degrees(audioManager.isPlaying ? 360 : 0))
                                                    .animation(
                                                        Animation.linear(duration: 8)
                                                            .repeatForever(autoreverses: false),
                                                        value: audioManager.isPlaying
                                                    )
                                                
                                                // Pulsing Sanskrit Om
                                                Text("ॐ")
                                                    .font(.system(size: audioManager.isPlaying ? 45 : 40))
                                                    .foregroundColor(.orange)
                                                    .scaleEffect(audioManager.isPlaying ? 1.1 : 1.0)
                                                    .animation(
                                                        Animation.easeInOut(duration: 1.5)
                                                            .repeatForever(autoreverses: true),
                                                        value: audioManager.isPlaying
                                                    )
                                                
                                                // Audio wave particles
                                                if audioManager.isPlaying {
                                                    AudioVisualizerView()
                                                }
                                            }
                                        )
                                        .scaleEffect(audioManager.isPlaying ? 1.05 : 1.0)
                                        .shadow(color: audioManager.isPlaying ? .yellow.opacity(0.5) : .black.opacity(0.2), 
                                               radius: audioManager.isPlaying ? 25 : 15, 
                                               x: 0, y: 8)
                                        .animation(.easeInOut(duration: 0.3), value: audioManager.isPlaying)
                                }
                                
                                // Track info card
                                VStack(spacing: 12) {
                                    Text(track.title)
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                    
                                    Text(track.artist)
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.black.opacity(0.2))
                                        .blur(radius: 10)
                                )
                            }
                        } else {
                            // No track selected
                            VStack(spacing: 20) {
                                Text("🎵")
                                    .font(.system(size: 80))
                                
                                Text("Select a track to begin")
                                    .font(.title3)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding(40)
                        }
                    
                        // Modern progress bar
                        if audioManager.currentTrack != nil {
                            VStack(spacing: 12) {
                                // Custom progress bar
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white.opacity(0.3))
                                            .frame(height: 6)
                                        
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.white, Color.yellow],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(
                                                width: geometry.size.width * (audioManager.duration > 0 ? audioManager.currentTime / audioManager.duration : 0),
                                                height: 6
                                            )
                                    }
                                }
                                .frame(height: 6)
                                
                                HStack {
                                    Text(formatTime(audioManager.currentTime))
                                    Spacer()
                                    Text(formatTime(audioManager.duration))
                                }
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.9))
                            }
                            .padding(.horizontal, 30)
                        }
                    
                        // Modern control buttons
                        HStack(spacing: 50) {
                            Button(action: {}) {
                                Image(systemName: "backward.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(
                                        Circle()
                                            .fill(Color.white.opacity(0.2))
                                            .blur(radius: 10)
                                    )
                            }
                            
                            Button(action: audioManager.togglePlayPause) {
                                Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.system(size: 70))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            
                            Button(action: {}) {
                                Image(systemName: "forward.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(
                                        Circle()
                                            .fill(Color.white.opacity(0.2))
                                            .blur(radius: 10)
                                    )
                            }
                        }
                        .padding(.vertical, 20)
                    
                        // Collapsible track sections
                        LazyVStack(spacing: 16) {
                            CollapsibleSection(title: "🎙 Introduction", tracks: [audioManager.playlist[0]])
                                .environmentObject(audioManager)
                            
                            CollapsibleSection(title: "🐘 Ganapathi Slokam", tracks: Array(audioManager.playlist[1...4]))
                                .environmentObject(audioManager)
                            
                            CollapsibleSection(title: "🎵 Saraswathi Slokam", tracks: Array(audioManager.playlist[5...8]))
                                .environmentObject(audioManager)
                            
                            CollapsibleSection(title: "🙏 Gurubrahma Slokam", tracks: Array(audioManager.playlist[9...12]))
                                .environmentObject(audioManager)
                            
                            CollapsibleSection(title: "🕰 Puja Sankalpam", tracks: [audioManager.playlist[13]])
                                .environmentObject(audioManager)
                            
                            CollapsibleSection(title: "🛕 Ganapathi Puja", tracks: Array(audioManager.playlist[14...15]))
                                .environmentObject(audioManager)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}



struct TrackRowView: View {
    let track: AudioTrack
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        ModernTrackRowView(track: track)
            .environmentObject(audioManager)
    }
}

struct AudioVisualizerView: View {
    @State private var animationValues = Array(repeating: 0.0, count: 12)
    
    var body: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(
                            colors: [Color.yellow, Color.orange, Color.red],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(width: 3, height: 20 + animationValues[i])
                    .offset(
                        x: cos(Double(i) * .pi / 6) * 80,
                        y: sin(Double(i) * .pi / 6) * 80
                    )
                    .rotationEffect(.degrees(Double(i) * 30))
                    .onAppear {
                        withAnimation(
                            Animation.easeInOut(duration: 0.5 + Double(i) * 0.1)
                                .repeatForever(autoreverses: true)
                        ) {
                            animationValues[i] = Double.random(in: 10...40)
                        }
                    }
            }
        }
    }
}

struct FloatingParticlesView: View {
    @State private var particles: [ParticleData] = []
    
    var body: some View {
        ZStack {
            ForEach(particles, id: \.id) { particle in
                Circle()
                    .fill(Color.yellow.opacity(0.6))
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .scaleEffect(particle.scale)
                    .opacity(particle.opacity)
            }
        }
        .onAppear {
            createParticles()
        }
    }
    
    private func createParticles() {
        for i in 0..<20 {
            let particle = ParticleData(
                id: i,
                position: CGPoint(
                    x: Double.random(in: 50...250),
                    y: Double.random(in: 50...250)
                ),
                size: Double.random(in: 4...12),
                scale: 1.0,
                opacity: 0.8
            )
            particles.append(particle)
            
            withAnimation(
                Animation.easeInOut(duration: Double.random(in: 2...4))
                    .repeatForever(autoreverses: true)
                    .delay(Double(i) * 0.1)
            ) {
                particles[i].scale = Double.random(in: 0.5...1.5)
                particles[i].opacity = Double.random(in: 0.3...0.9)
            }
        }
    }
}

struct ParticleData {
    let id: Int
    var position: CGPoint
    let size: Double
    var scale: Double
    var opacity: Double
}

struct CollapsibleSection: View {
    let title: String
    let tracks: [AudioTrack]
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
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 0.6, green: 0.1, blue: 0.2))
                    
                    Spacer()
                    
                    Text("\(tracks.count) track\(tracks.count == 1 ? "" : "s")")
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
                                    Color.white.opacity(0.25),
                                    Color.white.opacity(0.15)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Expandable tracks
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(tracks) { track in
                        ModernTrackRowView(track: track)
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

#Preview {
    AudioPlayerView()
        .environmentObject(AudioManager())
}