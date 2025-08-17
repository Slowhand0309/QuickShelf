//
//  UpdaterDelegate.swift
//  QuickShelf
//
//  Created by slowhand on 2025/08/17.
//

import Sparkle

final class UpdaterDelegate: NSObject, SPUStandardUserDriverDelegate, SPUUpdaterDelegate {
    weak var updaterController: SPUStandardUpdaterController?
    private let notifier: NotificationBridge

    init(notifier: NotificationBridge) {
        self.notifier = notifier
    }

    var supportsGentleScheduledUpdateReminders: Bool { true }

    func standardUserDriverShouldHandleShowingScheduledUpdate(_ update: SUAppcastItem,
                                                             andInImmediateFocus immediateFocus: Bool) -> Bool {
        return immediateFocus
    }

    func standardUserDriverWillHandleShowingUpdate(_ handleShowingUpdate: Bool,
                                                   forUpdate update: SUAppcastItem,
                                                   state: SPUUserUpdateState) {
        guard !handleShowingUpdate else { return }
        if !state.userInitiated { notifier.postGentleUpdate(version: update.displayVersionString) }
    }

    func standardUserDriverDidReceiveUserAttention(forUpdate update: SUAppcastItem) {
        notifier.clearGentleUpdate()
    }

    func standardUserDriverWillFinishUpdateSession() {
        notifier.clearGentleUpdate()
    }

    func updater(_ updater: SPUUpdater, willScheduleUpdateCheckAfterDelay delay: TimeInterval) {
        notifier.requestAuth()
    }
}
