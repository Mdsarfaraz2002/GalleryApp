//
//  SplashScreen.swift
//  GalleryApp
//
//  Created by Mohd Sarfaraz on 28/10/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var animate = false
    @Binding var isActive: Bool

    var body: some View {
        ZStack {
            // Background gradient for depth
            LinearGradient(
                colors: [Color.black, Color.purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // Animated shimmer logo
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .shadow(color: .purple.opacity(0.6), radius: 15, x: 0, y: 10)
                        .scaleEffect(animate ? 1.1 : 0.9)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animate)

                    Image(systemName: "photo.fill.on.rectangle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .shimmering(active: true)
                }

                VStack(spacing: 8) {
                    Text("Gallery")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shimmering(active: true)

                    Text("Beautiful photos, smooth experience.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .opacity(animate ? 1 : 0)
                        .animation(.easeIn(duration: 1.5).delay(0.6), value: animate)
                }
                .padding(.top, 10)
            }
            .scaleEffect(animate ? 1.0 : 0.8)
            .opacity(animate ? 1.0 : 0.6)
            .animation(.easeOut(duration: 1.2), value: animate)
        }
        .onAppear {
            animate = true

            // Auto-dismiss splash after 2.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.6)) {
                    isActive = false
                }
            }
        }
    }
}
