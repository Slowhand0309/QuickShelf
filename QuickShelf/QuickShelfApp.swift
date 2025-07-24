//
//  QuickShelfApp.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/04.
//

import SwiftUI
import HotKey
import MenuBarExtraAccess

@main
struct QuickShelfApp: App {
    @State private var isPresented = false
    @State private var statusItem: NSStatusItem?

    private let hotKey = HotKey(key: .s,
                                modifiers: [.command, .control])

    var body: some Scene {
        MenuBarExtra {
            ContentView()
        } label: {
            Image("Logo")
                .renderingMode(.template)
                .resizable()
                .frame(width: 18, height: 18)
        }
        .menuBarExtraStyle(.window)
        .menuBarExtraAccess(isPresented: $isPresented) { item in
            statusItem = item
            addRightClickMonitor()
            hotKey.keyDownHandler = { [] in
                item.button?.performClick(nil)
            }
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
//        menu.addItem(withTitle: "Preferences…", action: nil, keyEquivalent: ",")
//        menu.addItem(.separator())
        menu.addItem(withTitle: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q")
        item.menu = menu
        item.button?.performClick(nil)
        item.menu = nil
    }
}
