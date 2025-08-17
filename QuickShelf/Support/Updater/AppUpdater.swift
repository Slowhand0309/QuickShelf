//
//  AppUpdater.swift
//  QuickShelf
//
//  Created by slowhand on 2025/08/16.
//

import Sparkle

final class AppUpdater {
    private let notifier = NotificationBridge()
    private lazy var gentleDelegate = UpdaterDelegate(notifier: notifier)
    private lazy var updaterController = SPUStandardUpdaterController(
        startingUpdater: true, updaterDelegate: gentleDelegate, userDriverDelegate: gentleDelegate
    )

    init() {
        gentleDelegate.updaterController = updaterController
        notifier.configure()
    }

    func checkForUpdates() {
        updaterController.updater.checkForUpdates()
    }
}
