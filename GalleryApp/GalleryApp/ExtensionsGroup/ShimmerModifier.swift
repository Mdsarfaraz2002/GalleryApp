//
//  ShimmerModifier.swift
//  GalleryApp
//
//  Created by Mohd Sarfaraz on 28/10/25.
//

import SwiftUI

extension View {
    func shimmering(active: Bool) -> some View {
        modifier(ShimmerModifier(isActive: active))
    }
}

struct ShimmerModifier: ViewModifier {
    let isActive: Bool
    @State private var move = false

    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isActive {
                        // Gradient overlay for shimmer
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, Color.white.opacity(0.35), .clear]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .rotationEffect(.degrees(20))
                        .offset(x: move ? 250 : -250)
                        .animation(.linear(duration: 1.2).repeatForever(autoreverses: false), value: move)
                        .onAppear { move = true }
                    }
                }
            )
            .clipped()
    }
}

