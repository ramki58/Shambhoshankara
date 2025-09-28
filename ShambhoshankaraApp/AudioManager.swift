import Foundation
import AVFoundation
import Combine
import AudioToolbox

class AudioManager: ObservableObject {
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var currentTrack: AudioTrack?
    @Published var playlist: [AudioTrack] = []
    @Published var playlists: [Playlist] = []
    
    private var audioPlayer: AVAudioPlayer?
    private var avPlayer: AVPlayer?
    private var timer: Timer?
    
    init() {
        setupAudioSession()
        loadSampleTracks()
        loadSamplePlaylists()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func loadSampleTracks() {
        playlist = [
            AudioTrack(id: UUID(), title: "Introduction message by Chandra Shekar Bodapati", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-1.mp3"),
            AudioTrack(id: UUID(), title: "Ganapathi Slokam - Level 1", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-1.mp3"),
            AudioTrack(id: UUID(), title: "Ganapathi Slokam - Level 2", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-2.mp3"),
            AudioTrack(id: UUID(), title: "Ganapathi Slokam - Level 3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-3.mp3"),
            AudioTrack(id: UUID(), title: "Ganapathi Slokam - Level 4", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-4.mp3"),
            AudioTrack(id: UUID(), title: "Saraswathi Slokam - Level 1", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Pranodevi-1.mp3"),
            AudioTrack(id: UUID(), title: "Saraswathi Slokam - Level 2", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Pranodevi-2.mp3"),
            AudioTrack(id: UUID(), title: "Saraswathi Slokam - Level 3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Pranodevi-3.mp3"),
            AudioTrack(id: UUID(), title: "Saraswathi Slokam - Level 4", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Pranodevi-4.mp3"),
            AudioTrack(id: UUID(), title: "Gurubrahma Slokam - Level 1", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gurubrahma-1.mp3"),
            AudioTrack(id: UUID(), title: "Gurubrahma Slokam - Level 2", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gurubrahma-2.mp3"),
            AudioTrack(id: UUID(), title: "Gurubrahma Slokam - Level 3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gurubrahma-3.mp3"),
            AudioTrack(id: UUID(), title: "Gurubrahma Slokam - Level 4", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gurubrahma-4.mp3"),
            AudioTrack(id: UUID(), title: "Puja Sankalpam", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/PujaSankalpaminUSA.mp3"),
            AudioTrack(id: UUID(), title: "Ganapathi Puja - Level 3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/GanapathiPujaL3.mp3"),
            AudioTrack(id: UUID(), title: "Ganapathi Puja - Level 4", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/GanapathiPujaL4.mp3")
        ]
    }
    
    private func loadSamplePlaylists() {
        let ganapathiTracks = Array(playlist[1...4]) // Ganapathi tracks
        let saraswathiTracks = Array(playlist[5...8]) // Saraswathi tracks
        let gurubrahmaTracks = Array(playlist[9...12]) // Gurubrahma tracks
        let ganapathiPujaTracks = Array(playlist[14...15]) // Ganapathi Puja tracks
        playlists = [
            Playlist(id: UUID(), name: "🕉 Complete Collection", tracks: playlist),
            Playlist(id: UUID(), name: "🐘 Ganapathi Slokam", tracks: ganapathiTracks),
            Playlist(id: UUID(), name: "🎵 Saraswathi Slokam", tracks: saraswathiTracks),
            Playlist(id: UUID(), name: "🙏 Gurubrahma Slokam", tracks: gurubrahmaTracks),
            Playlist(id: UUID(), name: "🕍 Ganapathi Puja", tracks: ganapathiPujaTracks),
            Playlist(id: UUID(), name: "🕰 Puja Sankalpam", tracks: [playlist[13]]),
            Playlist(id: UUID(), name: "🎙 Introduction", tracks: [playlist[0]])
        ]
    }
    
    func play(track: AudioTrack) {
        currentTrack = track
        
        // Check if it's a URL or local file
        if track.fileName.hasPrefix("http") {
            // Stream from URL using AVPlayer
            if let url = URL(string: track.fileName) {
                avPlayer = AVPlayer(url: url)
                
                // Get actual duration when item is ready
                avPlayer?.currentItem?.asset.loadValuesAsynchronously(forKeys: ["duration"]) {
                    DispatchQueue.main.async {
                        if let item = self.avPlayer?.currentItem {
                            let duration = item.asset.duration
                            if duration.isValid && !duration.isIndefinite {
                                self.duration = CMTimeGetSeconds(duration)
                            } else {
                                self.duration = 0
                            }
                        }
                    }
                }
                
                avPlayer?.play()
                isPlaying = true
                startTimer()
            }
        } else {
            // Try local file
            if let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3") {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                    duration = audioPlayer?.duration ?? track.duration
                    isPlaying = true
                    startTimer()
                } catch {
                    print("Error playing audio: \(error)")
                    playSystemSound()
                }
            } else {
                playSystemSound()
            }
        }
    }
    
    private func playSystemSound() {
        AudioServicesPlaySystemSound(1016)
        isPlaying = true
        duration = 30
        startTimer()
    }
    
    func togglePlayPause() {
        if let player = avPlayer {
            if isPlaying {
                player.pause()
                isPlaying = false
                stopTimer()
            } else {
                player.play()
                isPlaying = true
                startTimer()
            }
        } else {
            isPlaying.toggle()
            if isPlaying {
                startTimer()
            } else {
                stopTimer()
            }
        }
    }
    
    func stop() {
        avPlayer?.pause()
        avPlayer?.seek(to: .zero)
        isPlaying = false
        currentTime = 0
        stopTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let player = self.avPlayer {
                // Sync with actual AVPlayer time
                let currentTime = CMTimeGetSeconds(player.currentTime())
                if currentTime.isFinite {
                    self.currentTime = currentTime
                }
                
                // Check if playback ended
                if let item = player.currentItem {
                    if item.currentTime() >= item.duration {
                        self.stop()
                    }
                }
            } else {
                // Fallback for non-streaming audio
                if self.currentTime < self.duration {
                    self.currentTime += 1
                } else {
                    self.stop()
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func createPlaylist(name: String, tracks: [AudioTrack]) {
        let newPlaylist = Playlist(id: UUID(), name: name, tracks: tracks)
        playlists.append(newPlaylist)
    }
}

struct AudioTrack: Identifiable, Hashable {
    let id: UUID
    let title: String
    let artist: String
    let duration: TimeInterval
    let fileName: String
}

struct Playlist: Identifiable {
    let id: UUID
    let name: String
    let tracks: [AudioTrack]
}