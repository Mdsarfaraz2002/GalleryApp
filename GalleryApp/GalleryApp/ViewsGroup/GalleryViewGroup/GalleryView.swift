//
//  GalleryView.swift
//  GalleryApp
//
//  Created by Mohd Sarfaraz on 28/10/25.
//

import SwiftUI


struct GalleryView: View {
    @StateObject private var viewModel = GalleryViewModel()
    @State private var selectedPhoto: Photo?
    @State private var showDetail = false
    @State private var layoutType: GridLayoutType = .grid3

    @State private var showShareSheet = false
    @State private var imageToShare: UIImage?
    @State private var showMenu = false
    @State private var isLoadingShare = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color.gray.opacity(0.4), Color.black.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                if viewModel.isLoadingPage && viewModel.photos.isEmpty {
                    LoadingGridView(layoutType: layoutType)
                } else {
                    ScrollView {
                        LazyVGrid(columns: layoutType.columns(for: UIScreen.main.bounds.width),
                                  spacing: layoutType.spacing) {
                            ForEach(viewModel.photos) { photo in
                                GalleryImageItem(photo: photo, cornerRadius: layoutType.cornerRadius)
                                    .onTapGesture {
                                        selectedPhoto = photo
                                        showDetail = true
                                    }
                                    .onLongPressGesture {
                                        selectedPhoto = photo
                                        withAnimation(.spring()) {
                                            showMenu = true
                                        }
                                    }
                                    .task {
                                        await viewModel.loadNextPageIfNeeded(currentItem: photo)
                                    }
                            }
                        }
                        .padding(.horizontal, 8)
                        .animation(.easeInOut, value: layoutType)
                    }
                }

                // Loading indicator for sharing
                if isLoadingShare {
                    ProgressView("Preparing image...")
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .transition(.scale)
                }
            }
            .navigationTitle("Gallery")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            layoutType = layoutType.next()
                        }
                    } label: {
                        Image(systemName: layoutType.iconName)
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.purple.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
            }
            .task { await viewModel.loadInitialIfNeeded() }
            .refreshable { await viewModel.refresh() }

            // Navigate to detail
            .navigationDestination(isPresented: $showDetail) {
                if let selectedPhoto = selectedPhoto,
                   let startIndex = viewModel.photos.firstIndex(of: selectedPhoto) {
                    DetailView(viewModel: viewModel, startIndex: startIndex)
                }
            }

            // Share sheet
            .sheet(isPresented: $showShareSheet) {
                if let imageToShare = imageToShare {
                    ShareSheet(items: [imageToShare])
                }
            }
        }
        .preferredColorScheme(.dark)

        // Long press menu
        .confirmationDialog("Options", isPresented: $showMenu, titleVisibility: .visible) {
            if let selectedPhoto = selectedPhoto {
                Button("Share") {
                    shareImage(photo: selectedPhoto)
                }
                Button("Delete", role: .destructive) {
                    deletePhoto(selectedPhoto)
                }
            }
        } message: {
            Text("Choose an action for the selected image.")
        }
    }

    // MARK: - Actions

    private func shareImage(photo: Photo) {
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
                        // Delay ensures dialog closes first
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

    private func deletePhoto(_ photo: Photo) {
        withAnimation(.easeInOut) {
            viewModel.photos.removeAll { $0.id == photo.id }
        }
    }
}


