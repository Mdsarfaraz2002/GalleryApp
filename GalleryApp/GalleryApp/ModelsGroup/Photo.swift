//
//  Photo.swift
//  GalleryApp
//
//  Created by Mohd Sarfaraz on 28/10/25.
//

import Foundation

struct Photo: Codable, Identifiable, Equatable {
    let id: String
    let author: String
    let download_url: String

    var description: String { "Captured by \(author) — A beautiful random scene from Picsum." }

    func thumbnailURL(width: Int, height: Int) -> URL {
        URL(string: "https://picsum.photos/id/\(id)/\(width)/\(height)")!
    }
}

