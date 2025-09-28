import SwiftUI

struct ContentView: View {
    @StateObject private var audioManager = AudioManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CategoryView(category: "Slokams")
                .environmentObject(audioManager)
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Slokams")
                }
                .tag(0)
            
            CategoryView(category: "Sandhya Vandhanam")
                .environmentObject(audioManager)
                .tabItem {
                    Image(systemName: "sun.max.fill")
                    Text("Sandhya")
                }
                .tag(1)
            
            CategoryView(category: "Mahanyasam")
                .environmentObject(audioManager)
                .tabItem {
                    Image(systemName: "hands.sparkles.fill")
                    Text("Mahanyasam")
                }
                .tag(2)
            
            CategoryView(category: "Sri Rudram")
                .environmentObject(audioManager)
                .tabItem {
                    Image(systemName: "flame.fill")
                    Text("Sri Rudram")
                }
                .tag(3)
            
            CategoryView(category: "Pancha Sookthams")
                .environmentObject(audioManager)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Pancha")
                }
                .tag(4)
            
            CategoryView(category: "Homam")
                .environmentObject(audioManager)
                .tabItem {
                    Image(systemName: "flame.circle.fill")
                    Text("Homam")
                }
                .tag(5)
        }
        .accentColor(Color(red: 0.9, green: 0.5, blue: 0.2))
        .onAppear {
            // Modern tab bar styling
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.95, green: 0.85, blue: 0.7, alpha: 0.95)
            
            // Selected tab color - brighter
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 1.0, green: 0.3, blue: 0.0, alpha: 1.0)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(red: 1.0, green: 0.3, blue: 0.0, alpha: 1.0)]
            
            // Unselected tab color - brighter
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(red: 0.8, green: 0.2, blue: 0.1, alpha: 0.9)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(red: 0.8, green: 0.2, blue: 0.1, alpha: 0.9)]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
}