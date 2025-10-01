import Foundation

class ProgressManager: ObservableObject {
    @Published var completedTracks: Set<String> = []
    @Published var practiceStreak: Int = 0
    @Published var totalPracticeTime: TimeInterval = 0
    @Published var lastPracticeDate: Date?
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadProgress()
    }
    
    func markTrackCompleted(_ trackId: String) {
        completedTracks.insert(trackId)
        updateStreak()
        saveProgress()
    }
    
    func addPracticeTime(_ duration: TimeInterval) {
        totalPracticeTime += duration
        saveProgress()
    }
    
    func getCompletionPercentage(for level: Int, category: String) -> Double {
        let tracks = getTracksForLevel(level, category: category)
        let completed = tracks.filter { completedTracks.contains($0.id.uuidString) }
        return tracks.isEmpty ? 0 : Double(completed.count) / Double(tracks.count)
    }
    
    func getLevelProgress(category: String) -> [Int: Double] {
        var progress: [Int: Double] = [:]
        for level in 1...4 {
            progress[level] = getCompletionPercentage(for: level, category: category)
        }
        return progress
    }
    
    private func updateStreak() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastDate = lastPracticeDate {
            let lastPracticeDay = Calendar.current.startOfDay(for: lastDate)
            let daysDifference = Calendar.current.dateComponents([.day], from: lastPracticeDay, to: today).day ?? 0
            
            if daysDifference == 1 {
                practiceStreak += 1
            } else if daysDifference > 1 {
                practiceStreak = 1
            }
        } else {
            practiceStreak = 1
        }
        
        lastPracticeDate = Date()
    }
    
    private func getTracksForLevel(_ level: Int, category: String) -> [AudioTrack] {
        // This would integrate with AudioDataManager
        return []
    }
    
    private func saveProgress() {
        userDefaults.set(Array(completedTracks), forKey: "completedTracks")
        userDefaults.set(practiceStreak, forKey: "practiceStreak")
        userDefaults.set(totalPracticeTime, forKey: "totalPracticeTime")
        userDefaults.set(lastPracticeDate, forKey: "lastPracticeDate")
    }
    
    private func loadProgress() {
        completedTracks = Set(userDefaults.array(forKey: "completedTracks") as? [String] ?? [])
        practiceStreak = userDefaults.integer(forKey: "practiceStreak")
        totalPracticeTime = userDefaults.double(forKey: "totalPracticeTime")
        lastPracticeDate = userDefaults.object(forKey: "lastPracticeDate") as? Date
    }
}