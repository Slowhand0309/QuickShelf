//
//  ShelfItemEditView.swift
//  QuickShelf
//
//  Created by slowhand on 2025/09/04.
//

import SwiftUI

struct ShelfItemEditView: View {
    let item: ShelfItem
    @Binding var text: String
    var onCommit: () -> Void
    var onCancel: () -> Void

    @FocusState private var focused: Bool

    var body: some View {
        HStack {
            if item.isDirectory {
                Image(systemName: "folder")
            } else {
                if ProcessInfo.isPreview {
                    Image(systemName: "text.page")
                } else {
                    Image(nsImage: NSWorkspace.shared.icon(forFile: item.url.path))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
            }

            TextField("New name", text: $text, onCommit: onCommit)
                .textFieldStyle(.roundedBorder)
                .focused($focused)
                .onAppear { focused = true }

            Spacer()
        }
        .padding(.all, 8)
        .onExitCommand { onCancel() }
    }
}

#Preview {
    @Previewable @State var text = ""
    ShelfItemEditView(
        item: ShelfItem(
            url: URL(filePath: "/path/to/fileName.txt")!,
            isDirectory: false
        ),
        text: $text,
        onCommit: {},
        onCancel: {}
    )
}
