import Foundation
import AVFoundation
import Combine
import AudioToolbox

class AudioManager: NSObject, ObservableObject {
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var currentTrack: AudioTrack?
    @Published var playlist: [AudioTrack] = []

    
    private var audioPlayer: AVAudioPlayer?
    private var avPlayer: AVPlayer?
    private var timer: Timer?
    
    override init() {
        super.init()
        setupAudioSession()
        loadSampleTracks()

    }
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
            print("✅ Audio session setup successful")
        } catch {
            print("❌ Failed to setup audio session: \(error)")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let playerItem = object as? AVPlayerItem {
                switch playerItem.status {
                case .readyToPlay:
                    print("AVPlayerItem ready to play")
                case .failed:
                    print("AVPlayerItem failed: \(playerItem.error?.localizedDescription ?? "Unknown error")")
                case .unknown:
                    print("AVPlayerItem status unknown")
                @unknown default:
                    print("AVPlayerItem unknown status")
                }
            }
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
            AudioTrack(id: UUID(), title: "Ganapathi Puja - Level 4", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/GanapathiPujaL4.mp3"),
            
            // Sri Rudram Namakam Lessons
            AudioTrack(id: UUID(), title: "Namakam Lesson 1 - Level 1", artist: "Sri Rudram", duration: 0, fileName: "RudraNamakam_P01_L1.mp3"),
            AudioTrack(id: UUID(), title: "Namakam Lesson 2 - Level 1", artist: "Sri Rudram", duration: 0, fileName: "RudraNamakam_P02_L1.mp3"),
            AudioTrack(id: UUID(), title: "Namakam Lesson 3 - Level 1", artist: "Sri Rudram", duration: 0, fileName: "RudraNamakam_P03_L1.mp3"),
            AudioTrack(id: UUID(), title: "Namakam Lesson 4 - Level 1", artist: "Sri Rudram", duration: 0, fileName: "RudraNamakam_P04_L1.mp3"),
            AudioTrack(id: UUID(), title: "Namakam Lesson 5 - Level 1", artist: "Sri Rudram", duration: 0, fileName: "RudraNamakam_P05_L1.mp3")
        ]
    }
    

    
    func play(track: AudioTrack) {
        print("=== PLAY FUNCTION CALLED ===")
        print("Track title: \(track.title)")
        print("Track fileName: \(track.fileName)")
        
        currentTrack = track
        
        // Stop any existing playback
        avPlayer?.pause()
        audioPlayer?.stop()
        
        // Check if it's a URL (http) or local file path
        if track.fileName.hasPrefix("http") {
            print("Detected HTTP URL")
            // Stream from URL using AVPlayer
            if let url = URL(string: track.fileName) {
                print("Creating AVPlayer for URL: \(url)")
                avPlayer = AVPlayer(url: url)
                
                // Get actual duration when item is ready
                avPlayer?.currentItem?.asset.loadValuesAsynchronously(forKeys: ["duration"]) {
                    DispatchQueue.main.async {
                        if let item = self.avPlayer?.currentItem {
                            let duration = item.asset.duration
                            if duration.isValid && !duration.isIndefinite {
                                self.duration = CMTimeGetSeconds(duration)
                                print("HTTP Duration loaded: \(self.duration) seconds")
                            } else {
                                self.duration = 0
                                print("HTTP Duration invalid or indefinite")
                            }
                        }
                    }
                }
                
                avPlayer?.play()
                isPlaying = true
                startTimer()
                print("HTTP AVPlayer play() called")
            }
        } else if track.fileName.hasPrefix("/") {
            print("Detected local file path")
            // Local file path - use AVPlayer
            let url = URL(fileURLWithPath: track.fileName)
            print("Full file path: \(url.path)")
            print("File URL: \(url)")
            
            // Check if file exists
            let fileExists = FileManager.default.fileExists(atPath: url.path)
            print("File exists: \(fileExists)")
            
            if fileExists {
                print("Creating AVPlayer for local file")
                avPlayer = AVPlayer(url: url)
                
                // Check AVPlayer creation
                if avPlayer != nil {
                    print("AVPlayer created successfully")
                } else {
                    print("Failed to create AVPlayer")
                    return
                }
                
                // Add observer for player status
                avPlayer?.currentItem?.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
                
                // Get actual duration when item is ready
                avPlayer?.currentItem?.asset.loadValuesAsynchronously(forKeys: ["duration"]) {
                    DispatchQueue.main.async {
                        if let item = self.avPlayer?.currentItem {
                            let duration = item.asset.duration
                            if duration.isValid && !duration.isIndefinite {
                                self.duration = CMTimeGetSeconds(duration)
                                print("Local Duration loaded: \(self.duration) seconds")
                            } else {
                                self.duration = 0
                                print("Local Duration invalid or indefinite")
                            }
                        }
                    }
                }
                
                // Set volume to maximum
                avPlayer?.volume = 1.0
                print("Set AVPlayer volume to: \(avPlayer?.volume ?? 0)")
                
                // Check audio session
                let session = AVAudioSession.sharedInstance()
                print("Audio session category: \(session.category)")
                print("Audio session output volume: \(session.outputVolume)")
                
                avPlayer?.play()
                isPlaying = true
                startTimer()
                print("Local AVPlayer play() called")
                
                // Check if actually playing after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if let player = self.avPlayer {
                        print("=== STATUS CHECK AFTER 2 SECONDS ===")
                        print("AVPlayer rate: \(player.rate)")
                        print("AVPlayer timeControlStatus: \(player.timeControlStatus.rawValue)")
                        print("AVPlayer current time: \(CMTimeGetSeconds(player.currentTime()))")
                        
                        if let item = player.currentItem {
                            print("PlayerItem status: \(item.status.rawValue)")
                            if let error = item.error {
                                print("PlayerItem error: \(error.localizedDescription)")
                            }
                        }
                        
                        if player.rate == 0 {
                            print("❌ AVPlayer not actually playing - rate is 0")
                        } else {
                            print("✅ AVPlayer is playing with rate: \(player.rate)")
                        }
                    }
                }
            } else {
                print("❌ File does not exist at path: \(url.path)")
                playSystemSound()
            }
        } else {
            print("Detected bundle resource")
            print("Looking for file: \(track.fileName).mp3")
            
            // List all bundle resources for debugging
            if let bundlePath = Bundle.main.resourcePath {
                print("Bundle path: \(bundlePath)")
                do {
                    let files = try FileManager.default.contentsOfDirectory(atPath: bundlePath)
                    let mp3Files = files.filter { $0.hasSuffix(".mp3") }
                    print("Found \(mp3Files.count) MP3 files in bundle")
                    
                    // Look for files that match our search pattern
                    let searchPattern = track.fileName.lowercased()
                    let matchingFiles = mp3Files.filter { $0.lowercased().contains(searchPattern.lowercased()) }
                    print("Files matching '\(searchPattern)': \(matchingFiles)")
                    
                    if let firstMatch = matchingFiles.first {
                        print("Using first match: \(firstMatch)")
                        let fileNameWithoutExtension = String(firstMatch.dropLast(4)) // Remove .mp3
                        
                        if let url = Bundle.main.url(forResource: fileNameWithoutExtension, withExtension: "mp3") {
                            print("✅ Found matching file: \(url)")
                            do {
                                audioPlayer = try AVAudioPlayer(contentsOf: url)
                                audioPlayer?.prepareToPlay()
                                audioPlayer?.play()
                                duration = audioPlayer?.duration ?? track.duration
                                isPlaying = true
                                startTimer()
                                print("✅ Successfully playing matched file!")
                                return // Exit early on success
                            } catch {
                                print("❌ Error playing matched audio: \(error)")
                            }
                        }
                    }
                } catch {
                    print("Error listing bundle contents: \(error)")
                }
            }
            
            // Try bundle resource
            if let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3") {
                print("✅ Found bundle resource: \(url)")
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                    duration = audioPlayer?.duration ?? track.duration
                    isPlaying = true
                    startTimer()
                    print("✅ Bundle AVAudioPlayer play() called")
                } catch {
                    print("❌ Error playing bundle audio: \(error)")
                    playSystemSound()
                }
            } else {
                print("❌ Bundle audio file not found: \(track.fileName).mp3")
                print("Trying alternative search...")
                
                // Try searching in audio_files subfolder
                if let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3", subdirectory: "audio_files") {
                    print("✅ Found in audio_files subfolder: \(url)")
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: url)
                        audioPlayer?.prepareToPlay()
                        audioPlayer?.play()
                        duration = audioPlayer?.duration ?? track.duration
                        isPlaying = true
                        startTimer()
                        print("✅ Subfolder AVAudioPlayer play() called")
                    } catch {
                        print("❌ Error playing subfolder audio: \(error)")
                        playSystemSound()
                    }
                } else {
                    print("❌ Audio file not found in bundle or audio_files subfolder")
                    playSystemSound()
                }
            }
        }
        
        print("=== END PLAY FUNCTION ===")
    }
    
    private func playSystemSound() {
        print("⚠️ Fallback to system sound - audio file not accessible")
        // Removed system sound to avoid confusion
        isPlaying = false
    }
    
    func formatTime(_ seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
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
    

}

struct AudioTrack: Identifiable, Hashable {
    let id: UUID
    let title: String
    let artist: String
    let duration: TimeInterval
    let fileName: String
}

