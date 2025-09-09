//
//  ShelfItemView.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/07.
//

import SwiftUI

struct ShelfItemView: View {
    @Environment(\.colorScheme) private var colorScheme

    let item: ShelfItem
    let isSelected: Bool
    let isMultiSelected: Bool
    let onPreview: (URL) -> Void
    let onEdit: () -> Void

    var body: some View {
        HStack {
            if ProcessInfo.isPreview {
                // Dummy image for preview
                if item.isDirectory {
                    Image(systemName: "folder")
                } else {
                    Image(systemName: "text.page")
                }
            } else {
                Image(nsImage: NSWorkspace.shared.icon(forFile: item.url.path))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            }
            Text(item.url.lastPathComponent)
                .foregroundColor(colorScheme == .dark ? .primary : .white.opacity(0.7))
            Spacer()
            if isSelected && !isMultiSelected {
                Button {
                    onPreview(item.url)
                } label: {
                    Image(systemName: "eye")
                }
                    .help("Preview")
                    .buttonStyle(.borderless)
                    .keyboardShortcut(.space, modifiers: [])
                    .opacity(!item.isDirectory ? 1 : 0)
                Button {
                    onEdit()
                } label: {
                    Image(systemName: "pencil")
                }
                    .help("Rename")
                    .buttonStyle(.borderless)
                    .keyboardShortcut(.return, modifiers: [])
            }
        }
        .padding(.all, 8)
    }
}

#Preview("file") {
    ShelfItemView(
        item: ShelfItem(
            url: URL(filePath: "/path/to/fileName.txt")!,
            isDirectory: false
        ),
        isSelected: false,
        isMultiSelected: false,
        onPreview: { url in print("Previewing: \(url)")},
        onEdit: {}
    )
}

#Preview("directory") {
    ShelfItemView(
        item: ShelfItem(
            url: URL(filePath: "/path/to/folderName")!,
            isDirectory: true
        ),
        isSelected: false,
        isMultiSelected: false,
        onPreview: { url in print("Previewing: \(url)")},
        onEdit: {}
    )
}
