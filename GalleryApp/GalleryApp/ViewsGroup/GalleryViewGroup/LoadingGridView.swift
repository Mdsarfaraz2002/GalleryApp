//
//  LoadingGridView.swift
//  GalleryApp
//
//  Created by Mohd Sarfaraz on 29/10/25.
//

import SwiftUI

// MARK: - Shimmer / Loading Placeholder
struct LoadingGridView: View {
    let layoutType: GridLayoutType
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layoutType.columns(for: UIScreen.main.bounds.width),
                      spacing: layoutType.spacing) {
                ForEach(0..<30, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: layoutType.cornerRadius)
                        .fill(Color.gray.opacity(0.25))
                        .aspectRatio(1, contentMode: .fit)
                        .shimmering(active: true)
                }
            }
            .padding()
        }
    }
}
