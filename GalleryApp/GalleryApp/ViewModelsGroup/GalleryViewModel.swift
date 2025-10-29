//
//  GalleryViewModel.swift
//  GalleryApp
//
//  Created by Mohd Sarfaraz on 28/10/25.
//

import SwiftUI

@MainActor
final class GalleryViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var isLoadingPage = false
    private let repo = PhotoRepository.shared

    func loadInitialIfNeeded() async {
        if photos.isEmpty {
            await loadNextPage()
        }
    }

    func refresh() async {
        await repo.reset()
        photos.removeAll()
        await loadNextPage()
    }

    func loadNextPageIfNeeded(currentItem item: Photo) async {
        guard let last = photos.last else { return }
        if item.id == last.id {
            await loadNextPage()
        }
    }

    private func loadNextPage() async {
        guard !isLoadingPage else { return }
        isLoadingPage = true
        defer { isLoadingPage = false }

        do {
            let new = try await repo.loadNextPage()
            photos = new
        } catch {
            print("Error: \(error)")
        }
    }
}
