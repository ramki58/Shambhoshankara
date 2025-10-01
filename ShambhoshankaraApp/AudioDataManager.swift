import Foundation

class AudioDataManager {
    static let shared = AudioDataManager()
    private let baseURL = "https://shambhoshankara.com/Audio/"
    
    private init() {}
    
    func getSlokamTracks() -> [AudioTrack] {
        return [
            AudioTrack(id: UUID(), title: "Introduction message by Chandra Shekar Bodapati - Audio Level-1", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Intro.mp3"),
            AudioTrack(id: UUID(), title: "Ganapathi Slokam - Audio Level-1", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-1.mp3"),
            AudioTrack(id: UUID(), title: "Ganapathi Slokam - Audio Level-2", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-2.mp3"),
            AudioTrack(id: UUID(), title: "Ganapathi Slokam - Audio Level-3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-3.mp3"),
            AudioTrack(id: UUID(), title: "Ganapathi Slokam - Audio Level-4", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-4.mp3"),
            AudioTrack(id: UUID(), title: "Saraswathi Slokam - Audio Level-1", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Pranodevi-1.mp3"),
            AudioTrack(id: UUID(), title: "Saraswathi Slokam - Audio Level-2", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Pranodevi-2.mp3"),
            AudioTrack(id: UUID(), title: "Saraswathi Slokam - Audio Level-3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Pranodevi-3.mp3"),
            AudioTrack(id: UUID(), title: "Saraswathi Slokam - Audio Level-4", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Pranodevi-4.mp3"),
            AudioTrack(id: UUID(), title: "Gurubrahma Slokam - Audio Level-1", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gurubrahma-1.mp3"),
            AudioTrack(id: UUID(), title: "Gurubrahma Slokam - Audio Level-2", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gurubrahma-2.mp3"),
            AudioTrack(id: UUID(), title: "Gurubrahma Slokam - Audio Level-3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gurubrahma-3.mp3"),
            AudioTrack(id: UUID(), title: "Gurubrahma Slokam - Audio Level-4", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gurubrahma-4.mp3"),
            AudioTrack(id: UUID(), title: "Ganapathi Puja - Audio Level-3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/GanapathiPujaL3.mp3"),
            AudioTrack(id: UUID(), title: "Ganapathi Puja - Audio Level-4", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/GanapathiPujaL4.mp3"),
            AudioTrack(id: UUID(), title: "Dasanga Rowdreekaranam - Audio Level-1", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/DasangaRowdreekaranamL1.mp3"),
            AudioTrack(id: UUID(), title: "Dasanga Rowdreekaranam - Audio Level-2", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/DasangaRowdreekaranamL2.mp3"),
            AudioTrack(id: UUID(), title: "Dasanga Rowdreekaranam - Audio Level-3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/DasangaRowdreekaranamL3.mp3"),
            AudioTrack(id: UUID(), title: "Dasanga Rowdreekaranam - Audio Level-4", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/DasangaRowdreekaranamL4.mp3")
        ]
    }
    
    func getSandhyaVandhanamTracks() -> [AudioTrack] {
        return [
            AudioTrack(id: UUID(), title: "Puja Sankalpam - Audio Level-1", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/PujaSankalpaminUSA.mp3"),
            AudioTrack(id: UUID(), title: "Yajurveda Sandhya Vandanam - Audio Level-1", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Sandhyavandanam.mp3"),
            AudioTrack(id: UUID(), title: "Rudra Sankalpam - Audio Level-1", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/RudraSankalpam_P00_L1.mp3"),
            AudioTrack(id: UUID(), title: "Rudra Sankalpam - Audio Level-2", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/RudraSankalpam_P00_L2.mp3"),
            AudioTrack(id: UUID(), title: "Rudra Sankalpam - Audio Level-3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/RudraSankalpam_P00_L3.mp3"),
            AudioTrack(id: UUID(), title: "Rudra Sankalpam - Audio Level-4", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/RudraSankalpam_P00_L4.mp3")
        ]
    }
    
    func getMahanyasamSections() -> [RudramSection] {
        var sections: [RudramSection] = []
        
        // Sample Mahanyasam tracks with working URLs
        let sampleTracks = [
            AudioTrack(id: UUID(), title: "Mahanyasam Lesson 1 - Level 1", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-1.mp3"),
            AudioTrack(id: UUID(), title: "Mahanyasam Lesson 1 - Level 2", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-2.mp3")
        ]
        sections.append(RudramSection(title: "Mahanyasam Lesson 1", tracks: sampleTracks))
        
        return sections
    }
    
    func getSriRudramSections() -> [RudramSection] {
        var sections: [RudramSection] = []
        
        // Sample Sri Rudram tracks with working URLs
        let namakamTracks = [
            AudioTrack(id: UUID(), title: "Namakam Lesson 1", artist: "Sri Rudram", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-1.mp3"),
            AudioTrack(id: UUID(), title: "Namakam Lesson 2", artist: "Sri Rudram", duration: 0, fileName: "https://shambhoshankara.com/Audio/Gananantva-2.mp3")
        ]
        sections.append(RudramSection(title: "Namakam Lessons", tracks: namakamTracks))
        
        let chamakamTracks = [
            AudioTrack(id: UUID(), title: "Chamakam Lesson 1", artist: "Sri Rudram", duration: 0, fileName: "https://shambhoshankara.com/Audio/Pranodevi-1.mp3"),
            AudioTrack(id: UUID(), title: "Chamakam Lesson 2", artist: "Sri Rudram", duration: 0, fileName: "https://shambhoshankara.com/Audio/Pranodevi-2.mp3")
        ]
        sections.append(RudramSection(title: "Chamakam Lessons", tracks: chamakamTracks))
        
        return sections
    }
    
    func getPanchaSookthams() -> [AudioTrack] {
        return [
            AudioTrack(id: UUID(), title: "Purusha Sooktam - Audio Level-3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/PurushaSooktamL3.mp3"),
            AudioTrack(id: UUID(), title: "Purusha Sooktam - Audio Level-4", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/PurushaSooktamL4.mp3"),
            AudioTrack(id: UUID(), title: "Sri Sooktam - Audio Level-3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/SriSooktamL3.mp3"),
            AudioTrack(id: UUID(), title: "Sri Sooktam - Audio Level-4", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/SriSooktamL4.mp3"),
            AudioTrack(id: UUID(), title: "Manyu Sooktam - Audio Level-1", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Manyu-1.mp3"),
            AudioTrack(id: UUID(), title: "Manyu Sooktam - Audio Level-3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Manyu-3.mp3"),
            AudioTrack(id: UUID(), title: "Durga Sooktam - Audio Level-3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/DurgaSooktam-3.mp3"),
            AudioTrack(id: UUID(), title: "Durga Sooktam - Audio Level-4", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/DurgaSooktam-4.mp3"),
            AudioTrack(id: UUID(), title: "Bhoo Sooktam - Audio Level-3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/Bhusuktam.mp3")
        ]
    }
    
    func getHomamTracks() -> [AudioTrack] {
        return [
            AudioTrack(id: UUID(), title: "Siva Puja - Audio Level-3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/SivaPujaL3.mp3"),
            AudioTrack(id: UUID(), title: "Jayadi Homam Part A - Audio Level-3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/JayadiAL3.mp3"),
            AudioTrack(id: UUID(), title: "Jayadi Homam Part B - Audio Level-3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/JayadiBL3.mp3"),
            AudioTrack(id: UUID(), title: "Prayaschitta Homam - Audio Level-3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/PrayaschittaHomamL3.mp3"),
            AudioTrack(id: UUID(), title: "Yagneswara Puja - Audio Level-3", artist: "Shambhoshankara", duration: 0, fileName: "https://shambhoshankara.com/Audio/YagneswaraPujaL3.mp3")
        ]
    }
    
    func getMahanyasamTracks() -> [AudioTrack] {
        var tracks: [AudioTrack] = []
        for lesson in 1...11 {
            for level in 1...4 {
                let title = "Mahanyasam Lesson \(lesson) - Audio Level-\(level)"
                let fileName = "https://shambhoshankara.com/Audio/Mahanyasam\(lesson)-\(level).mp3"
                tracks.append(AudioTrack(id: UUID(), title: title, artist: "Shambhoshankara", duration: 0, fileName: fileName))
            }
        }
        return tracks
    }
    
    func getSriRudramTracks() -> [AudioTrack] {
        var tracks: [AudioTrack] = []
        
        // Namakam Lessons (1-28)
        for lesson in 1...28 {
            for level in 1...4 {
                let title = "Namakam Lesson \(lesson) - Audio Level-\(level)"
                let fileName = "https://shambhoshankara.com/Audio/RudraNamakam_P\(String(format: "%02d", lesson))_L\(level).mp3"
                tracks.append(AudioTrack(id: UUID(), title: title, artist: "Sri Rudram", duration: 0, fileName: fileName))
            }
        }
        
        // Chamakam Lessons (1-13)
        for lesson in 1...13 {
            for level in 1...4 {
                let title = "Chamakam Lesson \(lesson) - Audio Level-\(level)"
                let fileName = "https://shambhoshankara.com/Audio/RudraChamakam_P\(String(format: "%02d", lesson))_L\(level).mp3"
                tracks.append(AudioTrack(id: UUID(), title: title, artist: "Sri Rudram", duration: 0, fileName: fileName))
            }
        }
        
        return tracks
    }
}