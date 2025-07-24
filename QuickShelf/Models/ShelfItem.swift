//
//  ShelfItem.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/07.
//

import Foundation
import CoreTransferable

final class ShelfItem: Hashable, Transferable {
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
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .item) { item in
            SentTransferredFile(item.url)
        } importing: { received in
            ShelfItem(url: received.file,
                      isDirectory: received.file.hasDirectoryPath)
        }
        ProxyRepresentation(exporting: \.url)
    }
}
