//
//  PhotoRepository.swift
//  GalleryApp
//
//  Created by Mohd Sarfaraz on 28/10/25.
//

import Foundation

actor PhotoRepository {
    static let shared = PhotoRepository()
    private var photos: [Photo] = []
    private var currentPage = 1
    private let limit = 30
    private var isLoading = false
    private var canLoadMore = true

    private let cacheFile: URL = {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("photos_cache.json")
    }()

    func loadNextPage() async throws -> [Photo] {
        guard !isLoading, canLoadMore else { return photos }
        isLoading = true
        defer { isLoading = false }

        do {
            let url = URL(string: "https://picsum.photos/v2/list?page=\(currentPage)&limit=\(limit)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let fetched = try JSONDecoder().decode([Photo].self, from: data)

            if fetched.isEmpty {
                canLoadMore = false
            } else {
                photos += fetched
                currentPage += 1
                try? JSONEncoder().encode(photos).write(to: cacheFile)
            }
        } catch {
            // Load from cache if network fails
            if let data = try? Data(contentsOf: cacheFile),
               let cached = try? JSONDecoder().decode([Photo].self, from: data) {
                photos = cached
            }
        }

        return photos
    }

    func reset() {
        photos.removeAll()
        currentPage = 1
        canLoadMore = true
    }
}

