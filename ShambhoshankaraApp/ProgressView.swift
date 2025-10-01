import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Progress Header with playlist button
                    HStack {
                        VStack(spacing: 16) {
                            Text("🕉")
                                .font(.system(size: 50))
                            
                            Text("Your Learning Journey")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack {
                            QuickPlaylistButton()
                            Spacer()
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    
                    // Stats Cards
                    HStack(spacing: 15) {
                        StatCard(
                            icon: "🔥",
                            title: "Streak",
                            value: "\(progressManager.practiceStreak)",
                            subtitle: "days"
                        )
                        
                        StatCard(
                            icon: "⏱️",
                            title: "Practice Time",
                            value: formatTotalTime(progressManager.totalPracticeTime),
                            subtitle: "total"
                        )
                        
                        StatCard(
                            icon: "✅",
                            title: "Completed",
                            value: "\(progressManager.completedTracks.count)",
                            subtitle: "tracks"
                        )
                    }
                    
                    // Sri Rudram Progress
                    ProgressSection(
                        title: "🔥 Sri Rudram Progress",
                        category: "Sri Rudram"
                    )
                    
                    // Other Categories Progress
                    ProgressSection(
                        title: "📿 Slokams Progress",
                        category: "Slokams"
                    )
                    
                    ProgressSection(
                        title: "🙏 Mahanyasam Progress",
                        category: "Mahanyasam"
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .background(
                LinearGradient(
                    colors: [Color(red: 0.9, green: 0.4, blue: 0.3), Color(red: 0.7, green: 0.2, blue: 0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationBarHidden(true)
        }
    }
    
    private func formatTotalTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = Int(seconds) % 3600 / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.title)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct ProgressSection: View {
    let title: String
    let category: String
    @EnvironmentObject var progressManager: ProgressManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                ForEach(1...4, id: \.self) { level in
                    LevelProgressRow(
                        level: level,
                        progress: progressManager.getCompletionPercentage(for: level, category: category)
                    )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct LevelProgressRow: View {
    let level: Int
    let progress: Double
    
    var body: some View {
        HStack {
            Text("Level \(level)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 60, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white)
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
            
            Text("\(Int(progress * 100))%")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 35, alignment: .trailing)
        }
    }
}

#Preview {
    ProgressView()
        .environmentObject(ProgressManager())
        .environmentObject(AudioManager())
}