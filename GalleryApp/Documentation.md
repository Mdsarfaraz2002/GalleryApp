//
//  Documentation.md
//  GalleryApp
//
//  Created by Mohd Sarfaraz on 29/10/25.
//

# GalleryApp

Offline-capable SwiftUI image gallery built with MVVM architecture.

## ✨ Features
- **MVVM architecture**
- **Online fetch from Picsum API** with JSON cache stored in the Documents directory
- **Local image caching** (Caches/photo_<id>.jpg)
- **Offline mode** – loads previously cached images when offline
- **Dynamic grid layouts** — switch between list / 3-grid / 4-grid views
- **Shimmer placeholders** while images load
- **Fullscreen detail viewer** with swipe navigation
- **Long-press actions** on any image:
  - 🖼️ **Share** — opens the iOS share sheet to share the selected image  
  - ❌ **Delete** — removes the image from the current gallery view
- **Smooth animations** and gesture handling
- **Unit tests (XCTest)** and **UI tests (XCUITest)** for stability

## 📁 Project Structure
GalleryApp/
│
├── Extensions/ # Shared modifiers & utilities
│ └── ShimmerModifier.swift
│
├── Models/ # Data models
│ ├── Photo.swift
│ └── GridLayoutType.swift
│
├── Services/ # Data and image managers
│ ├── ImageCacheService.swift
│ └── PhotoRepository.swift
│
├── ViewModels/ # Business logic layer
│ └── GalleryViewModel.swift
│
├── Views/ # UI Components
│ ├── GalleryViewGroup/
│ │ ├── GalleryView.swift
│ │ ├── GalleryImageItem.swift
│ │ ├── LoadingGridView.swift
│ │ └── ShareSheet.swift
│ │
│ ├── DetailViewGroup/
│ │ ├── DetailView.swift
│ │ └── DetailImageItem.swift
│ │
│ └── SplashScreen.swift
│
├── Assets.xcassets
├── ContentView.swift
└── GalleryAppApp.swift


## 🧠 Technical Highlights
- **Swift Concurrency (async/await)** for smooth network and disk operations  
- **Local caching strategy** — combines in-memory + on-disk caching  
- **Offline-first design** — app continues working without internet  
- **Dynamic gesture handling** — supports long-press, drag, and tap  

## ⚙️ Requirements
- Xcode **15.0+**
- iOS **16.0+**
- Swift **5.9+**

## ▶️ Run the App
1. Clone or download the project.  
2. Open **`GalleryApp.xcodeproj`** in Xcode.  
3. Select a simulator or device.  
4. Run the app (`Cmd + R`).  

## 🧪 Run Tests
Run unit tests from Terminal:
```bash
xcodebuild test -scheme GalleryApp -destination 'platform=iOS Simulator,name=iPhone 15'
