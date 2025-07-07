//
//  ShelfItemView.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/07.
//

import SwiftUI

struct ShelfItemView: View {
    let item: ShelfItem

    var body: some View {
        HStack {
            if item.isDirectory {
                Image(systemName: "folder")
            } else {
                Image(systemName: "text.page")
            }
            Text(item.url.lastPathComponent)
        }
        .padding(.all, 8)
    }
}

#Preview("file") {
    ShelfItemView(item: ShelfItem(
        url: URL(filePath: "/path/to/fileName.txt")!,
        isDirectory: false
    ))
}

#Preview("directory") {
    ShelfItemView(item: ShelfItem(
        url: URL(filePath: "/path/to/folderName")!,
        isDirectory: true
    ))
}
