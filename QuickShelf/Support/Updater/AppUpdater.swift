//
//  AppUpdater.swift
//  QuickShelf
//
//  Created by slowhand on 2025/08/16.
//

import Sparkle

final class AppUpdater {
    private let notifier = NotificationBridge()
    private lazy var delegate = UpdaterDelegate(notifier: notifier)
    private lazy var updaterController = SPUStandardUpdaterController(
        startingUpdater: true, updaterDelegate: delegate, userDriverDelegate: delegate
    )

    init() {
        delegate.updaterController = updaterController
        notifier.configure()
    }

    func checkForUpdates() {
        updaterController.updater.checkForUpdates()
    }
}
