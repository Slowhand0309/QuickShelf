//
//  Sequence+Sort.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/23.
//

import Foundation

extension Sequence where Element == ShelfItem {
    func standardSorted() -> [ShelfItem] {
        sorted {
            $0.url.lastPathComponent
                .localizedStandardCompare($1.url.lastPathComponent)
            == .orderedAscending
        }
    }
}
