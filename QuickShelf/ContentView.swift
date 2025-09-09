//
//  ContentView.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/04.
//

import AppKit
import SwiftUI
import QuickLook

struct ContentView: View {
    @Environment(\.openSettings) private var openSettings
    @AppStorage("preview.side")
    private var sideRaw: String = PreviewSide.right.rawValue

    private var side: PreviewSide { PreviewSide(rawValue: sideRaw) ?? .right }

    @State private var inputDir = ""
    @State private var items: [ShelfItem] = []
    @State private var selection = Set<URL>()
    @State private var previewUrl: URL?

    @State private var editingUrl: URL?
    @State private var renameText: String = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Folder")
                .font(.title3)
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
                .font(.title3)
            List(selection: $selection) {
                ForEach(items.standardSorted(), id: \.url) { item in
                    if editingUrl == item.url {
                        ShelfItemEditView(
                            item: item,
                            text: $renameText,
                            onCommit: { commitRename() },
                            onCancel: { cancelRename() }
                        )
                        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                        .listRowSeparatorTint(Color.white.opacity(0.3))
                        .tag(item.url)
                    } else {
                        ShelfItemView(
                            item: item,
                            isSelected: selection.contains(item.url),
                            onPreview: { url in
                                if let anchor = NSApp.keyWindow {
                                    SlidePanelPreview.shared.show(
                                        url: url, beside: anchor, side: side,
                                        size: NSSize(width: 380, height: 300)
                                    )
                                }
                            }
                        )
                        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                        .listRowSeparatorTint(Color.white.opacity(0.3))
                        .tag(item.url)
                        .draggable(item)
                        .contextMenu {
                            Button("Rename…") { startInlineRename() }
                                .disabled(selection.count != 1)
                        }
                    }
                }
            }
            .frame(height: 300)
            .scrollContentBackground(.hidden)
            .background(Color.black.opacity(0.3))
            HStack {
                Spacer()
                Button {
                    openSettings()
                } label: {
                    Image(systemName: "gear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.all, 18)
        .onAppear {
            selection = []
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
        .onDisappear { SlidePanelPreview.shared.hide() }

        // Press Enter to begin editing (only when one item is selected and not currently being edited)
        .overlay(
            Button(action: startInlineRename) { EmptyView() }
                .keyboardShortcut(.return, modifiers: [])
                .disabled(!(selection.count == 1 && editingUrl == nil))
                .frame(width: 0, height: 0)
                .opacity(0)
        )
        .overlay(alignment: .bottom) {
            if let msg = errorMessage {
                ErrorBannerView(message: msg) {
                    withAnimation { errorMessage = nil }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(10)
                .padding(.bottom, 8)
            }
        }
    }

    private func startInlineRename() {
        guard selection.count == 1, let url = selection.first else { return }
        editingUrl = url
        renameText = url.lastPathComponent
    }

    private func cancelRename() {
        editingUrl = nil
        renameText = ""
    }

    private func commitRename() {
        guard let src = editingUrl else { return }
        let newName = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !newName.isEmpty else { cancelRename(); return }

        let dir = src.deletingLastPathComponent()
        let dest = dir.appendingPathComponent(newName)

        if FileManager.default.fileExists(atPath: dest.path) {
            cancelRename();
            return
        }
        do {
            try FileManager.default.moveItem(at: src, to: dest)
            self.items = load(path: dir)
            self.selection = [dest]
            cancelRename()
        } catch {
            NSSound.beep()
            withAnimation { errorMessage = error.localizedDescription }
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
