//
//  Enums.swift
//  Proyecto
//
//  Created by Maria Eugenia Diaz Segura on 15/12/2021.
//

import Foundation

enum BtnMusic: CaseIterable {
    case download
    case add
    case trash
    case share
    case like

    var title : String {
        switch self {
        case .trash:
            return "Remove..."
        case .download:
            return "Download to library"
        case .add:
            return "Add to a Playlist..."
        case .share:
            return "Share song..."
        case .like:
                return "Love"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .trash:
            return UIImage(systemName: "trash")
        case .download:
            return UIImage(systemName: "square.and.arrow.down")
        case .add:
            return UIImage(systemName: "text.badge.plus")
        case .share:
            return UIImage(systemName: "arrowshape.turn.up.right")
        case .like:
            return UIImage(systemName: "heart")
        }
    }
}
