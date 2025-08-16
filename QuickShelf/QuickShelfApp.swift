//
//  QuickShelfApp.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/04.
//

import SwiftUI
import MenuBarExtraAccess
import KeyboardShortcuts

@main
struct QuickShelfApp: App {
    @Environment(\.openSettings) private var openSettings

    @State private var isPresented = false
    @State private var statusItem: NSStatusItem?


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
            KeyboardShortcuts.onKeyDown(for: .openShelfWindow) { [] in
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

        let updaterItem = NSMenuItem(
            title: "Check for Updates…",
            action: #selector(AppDelegate.checkForUpdates(_:)),
            keyEquivalent: ""
        )
        updaterItem.target = AppDelegate.shared
        menu.addItem(updaterItem)
        menu.addItem(.separator())

        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(AppDelegate.terminate(_:)),
            keyEquivalent: "q"
        )
        quitItem.target = AppDelegate.shared
        menu.addItem(quitItem)
        item.menu = menu
        item.button?.performClick(nil)
        item.menu = nil
    }
}

class AppDelegate: NSObject {
    static let shared = AppDelegate()
    var openSettings: OpenSettingsAction?

    private let updater = AppUpdater()

    @objc func openPreferences(_ sender: Any?) {
        openSettings?()
    }

    @objc func checkForUpdates(_ sender: Any?) {
        updater.checkForUpdates()
    }

    @objc func terminate(_ sender: Any?) {
        SecurityScope.shared.endAccess()
        NSApp.terminate(sender)
    }
}
