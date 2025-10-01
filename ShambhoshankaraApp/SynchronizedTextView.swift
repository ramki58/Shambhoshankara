import SwiftUI

struct SynchronizedTextView: View {
    let track: AudioTrack
    @EnvironmentObject var audioManager: AudioManager
    @State private var currentSegment: TextSegment?
    @State private var showingZoomedImage = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("📖")
                    .font(.title2)
                Text("Follow Along")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal)
            
            // Text Display
            if let segment = currentSegment {
                VStack(spacing: 12) {
                    // Image (if available)
                    if let imageName = segment.imageName {
                        VStack {
                            Text("Tap image to zoom")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.caption)
                            
                            if let uiImage = UIImage(named: imageName) {
                                Button(action: {
                                    showingZoomedImage = true
                                }) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                VStack {
                                    Image(systemName: "photo")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white.opacity(0.5))
                                    
                                    Text("Image not found: \(imageName)")
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.caption)
                                }
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        .sheet(isPresented: $showingZoomedImage) {
                            ZoomedImageView(imageName: imageName)
                        }
                    }
                    
                    // Telugu Text (only if not empty)
                    if !segment.telugu.isEmpty {
                        Text(segment.telugu)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // Transliteration (only if not empty)
                    if !segment.transliteration.isEmpty {
                        Text(segment.transliteration)
                            .font(.body)
                            .italic()
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // Meaning (if available)
                    if let meaning = segment.meaning {
                        Text(meaning)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
                .transition(.opacity.combined(with: .scale))
            } else {
                // Placeholder when no text is available
                VStack(spacing: 8) {
                    Text("🕉")
                        .font(.system(size: 40))
                    
                    Text("Text will appear here during playback")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
            }
        }
        .padding(.horizontal)
        .onReceive(audioManager.$currentTime) { currentTime in
            updateCurrentSegment(currentTime)
        }
        .onAppear {
            if audioManager.currentTrack?.fileName != track.fileName {
                audioManager.play(track: track)
            }
            updateCurrentSegment(audioManager.currentTime)
        }
    }
    
    private func updateCurrentSegment(_ currentTime: TimeInterval) {
        let newSegment = SriRudramTextManager.shared.getCurrentSegment(
            for: track.fileName,
            at: currentTime
        )
        
        if newSegment?.sanskrit != currentSegment?.sanskrit {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentSegment = newSegment
            }
        }
    }
}

struct ZoomedImageView: View {
    let imageName: String
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView([.horizontal, .vertical]) {
                    if let uiImage = UIImage(named: imageName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(scale)
                            .offset(offset)
                            .gesture(
                                SimultaneousGesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            scale = max(1.0, min(value, 5.0))
                                        },
                                    DragGesture()
                                        .onChanged { value in
                                            offset = value.translation
                                        }
                                        .onEnded { _ in
                                            withAnimation {
                                                offset = .zero
                                            }
                                        }
                                )
                            )
                    }
                }
            }
            .background(Color.black)
            .navigationTitle("Zoom View")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        withAnimation {
                            scale = 1.0
                            offset = .zero
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let sampleTrack = AudioTrack(
        id: UUID(),
        title: "Namakam Lesson 1 - Level 1",
        artist: "Sri Rudram",
        duration: 180,
        fileName: "RudraNamakam_P01_L1.mp3"
    )
    
    return SynchronizedTextView(track: sampleTrack)
        .environmentObject(AudioManager())
        .background(Color.red)
}