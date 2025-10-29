//
//  DetailImageItem.swift
//  GalleryApp
//
//  Created by Mohd Sarfaraz on 28/10/25.
//

import SwiftUI

struct DetailImageItem: View {
    let photo: Photo
    @StateObject private var loader = ImageLoaderWithCache()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .shimmering(active: loader.isLoading)
            }
        }
        .onAppear { loader.loadImage(photo: photo) }
        .onDisappear { loader.cancel() }
    }
}

