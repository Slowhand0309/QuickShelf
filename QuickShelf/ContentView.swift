//
//  ContentView.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/04.
//

import SwiftUI

struct ContentView: View {
    @State private var inputDir = ""
    @State private var items: [URL] = []

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
                ForEach(items, id: \.self) { item in
                    Text("\(item.lastPathComponent)")
                }
            }
            .frame(height: 300)
            .scrollContentBackground(.hidden)
            .background(Color.black.opacity(0.3))
        }
        .padding(.all, 16)
    }

    private func openPanel() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.begin { result in
            guard result == .OK, let url = panel.url else { return }
            let bookmark = try? url.bookmarkData(options: .withSecurityScope,
                                                includingResourceValuesForKeys: nil,
                                                relativeTo: nil)
            UserDefaults.standard.set(bookmark, forKey: "user_selected_dir")
            self.items = load(path: url)
            self.inputDir = url.relativePath
        }
    }

    private func load(path: URL) -> [URL] {
        let result = try? FileManager.default.contentsOfDirectory(
            at: path,
            includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey],
            options: [.skipsHiddenFiles])
        return result ?? []
    }
}

#Preview {
    ContentView()
}
