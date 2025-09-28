# 🕉 Shambhoshankara Audio Player

A modern iOS app for devotees to listen to Shambhoshankara audio files with beautiful UI and playlist functionality.

## Features

- **Modern SwiftUI Interface** with devotional color scheme (orange/purple gradients)
- **Audio Playback** with play/pause controls and progress tracking
- **Playlist Management** - Create and manage custom playlists
- **Beautiful Design** with gradient backgrounds and smooth animations
- **Devotional Aesthetics** with Om symbol and spiritual themes

## Architecture

- **SwiftUI** for declarative UI
- **AVFoundation** for audio playback
- **Combine** for reactive programming
- **MVVM Pattern** with ObservableObject

## Getting Started

1. Open `ShambhoshankaraApp.xcodeproj` in Xcode
2. Select your target device/simulator
3. Build and run the project

## Project Structure

```
ShambhoshankaraApp/
├── ShambhoshankaraApp.swift    # App entry point
├── ContentView.swift           # Main tab view
├── AudioPlayerView.swift       # Audio player interface
├── PlaylistView.swift          # Playlist management
├── AudioManager.swift          # Audio playback logic
├── Assets.xcassets/           # App assets
└── Info.plist                # App configuration
```

## Key Components

### AudioManager
- Handles audio playback using AVFoundation
- Manages playlists and tracks
- Observable object for UI updates

### AudioPlayerView
- Main player interface with controls
- Progress bar and time display
- Track list with modern card design

### PlaylistView
- Create and manage playlists
- Beautiful playlist cards
- Track selection interface

## Design Features

- **Gradient Backgrounds**: Orange to purple devotional theme
- **Modern Cards**: Rounded corners with shadows
- **Smooth Animations**: Native SwiftUI transitions
- **Accessibility**: VoiceOver support built-in
- **Responsive Design**: Works on all iPhone sizes

## Next Steps

1. **Add Real Audio Files**: Replace sample tracks with actual audio files
2. **Cloud Storage**: Integrate with AWS S3 or similar for audio hosting
3. **Offline Support**: Download tracks for offline listening
4. **Search Functionality**: Add search for tracks and playlists
5. **User Accounts**: Add user authentication and cloud sync
6. **Social Features**: Share playlists with other devotees

## Development Time Estimate

- **Basic Version (Current)**: 2-3 weeks
- **With Real Audio Integration**: 4-5 weeks  
- **Full Featured App**: 8-12 weeks

The current implementation provides a solid foundation with modern UI and core functionality that can be extended with additional features as needed.