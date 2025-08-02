//
//  SecurityScope.swift
//  QuickShelf
//
//  Created by slowhand on 2025/08/02.
//

import Foundation

final class SecurityScope {
    static let shared = SecurityScope()
    private var scopedUrl: URL?

    func beginAccess(for url: URL) -> Bool {
        if let url = scopedUrl {
            url.stopAccessingSecurityScopedResource()
        }
        if url.startAccessingSecurityScopedResource() {
            scopedUrl = url
            return true
        }
        return false
    }

    func endAccess() {
        scopedUrl?.stopAccessingSecurityScopedResource()
        scopedUrl = nil
    }
}
