//
//  ImageCacheService.swift
//  GalleryApp
//
//  Created by Mohd Sarfaraz on 28/10/25.
//

import SwiftUI

@MainActor
final class ImageLoaderWithCache: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    private var task: Task<Void, Never>?

    // Returns a local cache URL for the given photo.
    func localFileURL(for photo: Photo) -> URL {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("photo_\(photo.id).jpg")
    }

    // Loads an image either from cache or network.
    func loadImage(photo: Photo, thumbnail: Bool = false) {
        let localURL = localFileURL(for: photo)
        let url = thumbnail ? photo.thumbnailURL(width: 400, height: 400) : URL(string: photo.download_url)!
        
        // If cached locally
        if let data = try? Data(contentsOf: localURL),
           let img = UIImage(data: data) {
            self.image = img
            return
        }

        // Otherwise, fetch from network
        isLoading = true
        task = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let img = UIImage(data: data) {
                    try? data.write(to: localURL)
                    await MainActor.run {
                        self.image = img
                    }
                }
            } catch {
                print("Image load failed: \(error)")
            }
            await MainActor.run { self.isLoading = false }
        }
    }

    func cancel() {
        task?.cancel()
    }
}

