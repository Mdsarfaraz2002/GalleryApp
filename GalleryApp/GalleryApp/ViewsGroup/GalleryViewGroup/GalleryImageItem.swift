//
//  GalleryImageItem.swift
//  GalleryApp
//
//  Created by Mohd Sarfaraz on 28/10/25.
//

import SwiftUI

struct GalleryImageItem: View {
    let photo: Photo
    let cornerRadius: CGFloat
    @StateObject private var loader = ImageLoaderWithCache()

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.gray.opacity(0.25))
                .aspectRatio(1, contentMode: .fit)
                .shimmering(active: loader.isLoading)

            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(1, contentMode: .fit)
                    .clipped()
                    .cornerRadius(cornerRadius)
            }
        }
        .onAppear { loader.loadImage(photo: photo, thumbnail: true) }
        .onDisappear { loader.cancel() }
    }
}
