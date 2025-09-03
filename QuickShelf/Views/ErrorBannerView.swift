//
//  ErrorBannerView.swift
//  QuickShelf
//
//  Created by slowhand on 2025/09/04.
//

import SwiftUI

struct ErrorBannerView: View {
    @State private var autoHideTaskID = UUID()

    let message: String
    var onClose: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
            Text(message)
                .lineLimit(2)
                .truncationMode(.tail)
            Spacer()
            Button {
                onClose()
            } label: {
                Image(systemName: "xmark")
            }
            .buttonStyle(.plain)
            .keyboardShortcut(.cancelAction)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.regularMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.red.opacity(0.6), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 8)
        .task(id: message) {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            await MainActor.run { onClose() }
        }
    }
}

#Preview {
    ErrorBannerView(
        message: "message",
        onClose: {}
    )
}
