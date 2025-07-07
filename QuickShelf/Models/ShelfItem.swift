//
//  ShelfItem.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/07.
//

import Foundation

final class ShelfItem: Hashable {
    static func == (lhs: ShelfItem, rhs: ShelfItem) -> Bool {
        return lhs.url == rhs.url
    }
    
    var url: URL
    var isDirectory: Bool
    
    init(url: URL, isDirectory: Bool) {
        self.url = url
        self.isDirectory = isDirectory
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}
