//
//  ContentView.swift
//  GalleryApp
//
//  Created by Mohd Sarfaraz on 27/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashScreen(isActive: $showSplash)
                    .transition(.opacity)
            } else {
                GalleryView()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.6), value: showSplash)
    }
}

