//
//  ProcessInfo+Preview.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/15.
//

import SwiftUI

extension ProcessInfo {
    static var isPreview: Bool {
        processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
