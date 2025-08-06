//
//  ContentView.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/04.
//

import SwiftUI

struct ContentView: View {
    @State private var inputDir = ""
    @State private var items: [ShelfItem] = []

    var body: some View {
        VStack(alignment: .leading) {
            Text("Directory")
            HStack {
                TextField("Please select directory", text: $inputDir)
                    .disabled(true)
                Button {
                    openPanel()
                } label: {
                    Image(systemName: "folder")
                }
            }
            Text("Items")
            List {
                ForEach(items.standardSorted(), id: \.url) { item in
                    ShelfItemView(item: item)
                        .alignmentGuide(.listRowSeparatorLeading) { _ in  0 }
                        .listRowSeparatorTint(Color.white.opacity(0.3))
                        .draggable(item)
                }
            }
            .frame(height: 300)
            .scrollContentBackground(.hidden)
            .background(Color.black.opacity(0.3))
        }
        .padding(.all, 18)
        .onAppear {
            if let data = UserDefaults.standard.data(forKey: "user_selected_dir") {
                var stale = false
                if let url = try? URL(resolvingBookmarkData: data,
                                            options: [.withSecurityScope],
                                            bookmarkDataIsStale: &stale),
                   SecurityScope.shared.beginAccess(for: url) {
                    self.items = load(path: url)
                    self.inputDir = url.relativePath
                }
            }
        }
    }

    private func openPanel() {
        // If the app is inactive, the sidebar cannot be selected, so I'll activate it.
        NSApp.activate()

        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.begin { result in
            guard result == .OK, let url = panel.url else { return }
            if let bookmark = try? url.bookmarkData(options: .withSecurityScope,
                                                includingResourceValuesForKeys: nil,
                                                    relativeTo: nil),
               SecurityScope.shared.beginAccess(for: url) {
                UserDefaults.standard.set(bookmark, forKey: "user_selected_dir")
                self.items = load(path: url)
                self.inputDir = url.relativePath
            }
        }
        panel.orderFrontRegardless()
    }

    private func load(path: URL) -> [ShelfItem] {
        let result = try? FileManager.default.contentsOfDirectory(
            at: path,
            includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey],
            options: [.skipsHiddenFiles])
        return result?.compactMap({ url -> ShelfItem? in
            let values = try? url.resourceValues(forKeys: [.isDirectoryKey, .fileSizeKey])
            guard let isDirectory = values?.isDirectory as? Bool else { return nil }
            return ShelfItem(url: url, isDirectory: isDirectory)
        }) ?? []
    }
}

#Preview {
    ContentView()
}
