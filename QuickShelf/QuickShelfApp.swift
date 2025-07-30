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
    @Environment(\.openSettings) private var openSettings

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
                .onAppear {
                    AppDelegate.shared.openSettings = openSettings
                }
        }
        .menuBarExtraStyle(.window)
        .menuBarExtraAccess(isPresented: $isPresented) { item in
            statusItem = item
            addRightClickMonitor()
            hotKey.keyDownHandler = { [] in
                item.button?.performClick(nil)
            }
        }

        Settings { SettingsView() }
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
        let settingsItem = NSMenuItem(
            title: "Preferences…",
            action: #selector(AppDelegate.openPreferences),
            keyEquivalent: ","
        )
        settingsItem.target = AppDelegate.shared
        menu.addItem(settingsItem)
        menu.addItem(.separator())
        menu.addItem(withTitle: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q")
        item.menu = menu
        item.button?.performClick(nil)
        item.menu = nil
    }
}

class AppDelegate: NSObject {
    static let shared = AppDelegate()
    var openSettings: OpenSettingsAction?

    @objc func openPreferences(_ sender: Any?) {
        openSettings?()
    }
}
