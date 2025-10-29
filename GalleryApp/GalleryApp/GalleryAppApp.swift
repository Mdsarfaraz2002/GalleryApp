//
//  GalleryAppApp.swift
//  GalleryApp
//
//  Created by Mohd Sarfaraz on 27/10/25.
//

import SwiftUI

@main
struct GalleryAppApp: App {
//    init() {
//        // Force dark mode for the entire app
//        UIView.appearance().overrideUserInterfaceStyle = .dark
//    }

    var body: some Scene {
        WindowGroup {
           // GalleryView()
            ContentView()
                .preferredColorScheme(.dark) // ensures dark theme in SwiftUI
                .background(Color.black.ignoresSafeArea())
        }
    }
}



