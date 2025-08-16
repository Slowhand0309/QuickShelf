//
//  AppUpdater.swift
//  QuickShelf
//
//  Created by slowhand on 2025/08/16.
//

import Sparkle

final class AppUpdater {
    private let updaterController = SPUStandardUpdaterController(
        startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil
    )

    func checkForUpdates() {
        updaterController.updater.checkForUpdates()
    }
}
