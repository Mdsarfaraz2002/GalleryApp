//
//  DetailView.swift
//  GalleryApp
//
//  Created by Mohd Sarfaraz on 26/10/25.
//

import SwiftUI


struct DetailView: View {
    @ObservedObject var viewModel: GalleryViewModel
    @State private var currentIndex: Int
    
    // For sharing and deleting
    @State private var showShareSheet = false
    @State private var imageToShare: UIImage?
    @State private var showMenu = false
    @State private var isLoadingShare = false

    init(viewModel: GalleryViewModel, startIndex: Int) {
        self.viewModel = viewModel
        _currentIndex = State(initialValue: startIndex)
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.gray.opacity(0.4), Color.black.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Image pager
            TabView(selection: $currentIndex) {
                ForEach(Array(viewModel.photos.enumerated()), id: \.element.id) { index, photo in
                    VStack(alignment: .leading, spacing: 6) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(photo.author)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(photo.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            LinearGradient(colors: [Color.black.opacity(0.8), .clear],
                                           startPoint: .bottom, endPoint: .top)
                        )

                        // Image with long press gesture
                        DetailImageItem(photo: photo)
                            .onLongPressGesture {
                                withAnimation(.spring()) {
                                    showMenu = true
                                }
                            }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            // Loading indicator while preparing share
            if isLoadingShare {
                ProgressView("Preparing image...")
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .transition(.scale)
            }
        }

        // Share Sheet
        .sheet(isPresented: $showShareSheet) {
            if let imageToShare = imageToShare {
                ShareSheet(items: [imageToShare])
            }
        }

        // Long press menu (Share / Delete)
        .confirmationDialog("Options", isPresented: $showMenu, titleVisibility: .visible) {
            Button("Share") {
                shareCurrentImage()
            }
            Button("Delete", role: .destructive) {
                deleteCurrentImage()
            }
        } message: {
            Text("Choose an action for the current image.")
        }
    }

    // MARK: - Actions

    private func shareCurrentImage() {
        guard currentIndex < viewModel.photos.count else { return }
        let photo = viewModel.photos[currentIndex]
        isLoadingShare = true
        
        Task {
            guard let url = URL(string: photo.download_url) else {
                await MainActor.run { isLoadingShare = false }
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        imageToShare = uiImage
                        isLoadingShare = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showShareSheet = true
                        }
                    }
                }
            } catch {
                await MainActor.run { isLoadingShare = false }
                print("Failed to load image for sharing:", error)
            }
        }
    }

    private func deleteCurrentImage() {
        guard currentIndex < viewModel.photos.count else { return }
        withAnimation(.easeInOut) {
            viewModel.photos.remove(at: currentIndex)
            if currentIndex >= viewModel.photos.count {
                currentIndex = max(0, viewModel.photos.count - 1)
            }
        }
    }
}


