//
//  Bundle+Info.swift
//  QuickShelf
//
//  Created by slowhand on 2025/08/02.
//

import Foundation

extension Bundle {
    var displayName: String {
        object(forInfoDictionaryKey: "CFBundleDisplayName")
            as? String ??
        object(forInfoDictionaryKey: "CFBundleName")
            as? String ??
        "QuickShelf"
    }

    var fullVersion: String {
        let version = object(forInfoDictionaryKey: "CFBundleShortVersionString")
            as? String ?? "-"
        return "\(version)"
    }
}
