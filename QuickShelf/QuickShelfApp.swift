//
//  QuickShelfApp.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/04.
//

import SwiftUI
import MenuBarExtraAccess

@main
struct QuickShelfApp: App {
    @State private var isPresented = false
    @State private var statusItem: NSStatusItem?

    var body: some Scene {
        MenuBarExtra(
            "QuickShelf",
            systemImage: "folder.fill" // TODO: アイコン検討
        ) {
            ContentView()
                .frame(width: 300, height: 180)
        }
        .menuBarExtraStyle(.window)
        .menuBarExtraAccess(isPresented: $isPresented) { item in
            statusItem = item
            addRightClickMonitor()
        }
    }

    private func addRightClickMonitor() {
        guard let item = statusItem else { return }
        NSEvent.addLocalMonitorForEvents(matching: .rightMouseDown) { event in
            if event.window == item.button?.window {
                popupContextMenu(for: item)
                return nil
            }
            return event
        }
    }

    private func popupContextMenu(for item: NSStatusItem) {
        let menu = NSMenu()
        menu.addItem(withTitle: "Preferences…", action: nil, keyEquivalent: ",")
        menu.addItem(.separator())
        menu.addItem(withTitle: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q")
        item.menu = menu
        item.button?.performClick(nil)
        item.menu = nil
    }
}
