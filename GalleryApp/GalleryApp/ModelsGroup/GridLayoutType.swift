//
//  GridLayoutType.swift
//  GalleryApp
//
//  Created by Mohd Sarfaraz on 28/10/25.
//

import Foundation
import SwiftUI

enum GridLayoutType: CaseIterable {
    case list, grid3, grid4

    var iconName: String {
        switch self {
        case .list: return "list.bullet"
        case .grid3: return "square.grid.3x2"
        case .grid4: return "square.grid.4x3.fill"
        }
    }

    func columns(for width: CGFloat) -> [GridItem] {
        switch self {
        case .list: return [GridItem(.flexible())]
        case .grid3: return Array(repeating: GridItem(.flexible(), spacing: spacing), count: 3)
        case .grid4: return Array(repeating: GridItem(.flexible(), spacing: spacing), count: 4)
        }
    }

    var spacing: CGFloat {
        switch self {
        case .list: return 12
        case .grid3: return 10
        case .grid4: return 8
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .list: return 14
        case .grid3: return 10
        case .grid4: return 8
        }
    }

    func next() -> GridLayoutType {
        switch self {
        case .list: return .grid3
        case .grid3: return .grid4
        case .grid4: return .list
        }
    }
}
