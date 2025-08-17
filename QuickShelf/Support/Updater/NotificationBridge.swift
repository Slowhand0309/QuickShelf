//
//  NotificationBridge.swift
//  QuickShelf
//
//  Created by slowhand on 2025/08/17.
//

import UserNotifications

final class NotificationBridge: NSObject, UNUserNotificationCenterDelegate {
    func configure() {
        UNUserNotificationCenter.current().delegate = self
    }
    func requestAuth() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in }
    }
    func postGentleUpdate(version: String) {
        let content = UNMutableNotificationContent()
        content.title = "Update available"
        content.body  = "Version \(version) is now available"
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: "QS_UPDATE", content: content, trigger: nil)
        )
    }
    func clearGentleUpdate() {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["QS_UPDATE"])
    }
}
