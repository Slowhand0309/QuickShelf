//
//  GeneralView.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/31.
//

import SwiftUI
import KeyboardShortcuts
import LaunchAtLogin

enum PreviewSide: String, CaseIterable, Identifiable {
    case left, right
    var id: String { rawValue }
}

struct GeneralView: View {
    @AppStorage("preview.side")
    private var sideRaw: String = PreviewSide.right.rawValue

    var body: some View {
        VStack(alignment: .leading) {
            Text("General")
                .font(.title)
                .padding(.bottom, 18)
            LaunchAtLogin.Toggle()
                .padding(.bottom, 8)
            Picker("Preview position", selection: Binding(
                get: { PreviewSide(rawValue: sideRaw) ?? .right },
                set: { sideRaw = $0.rawValue }
            )) {
                Text("Left").tag(PreviewSide.left)
                Text("Right").tag(PreviewSide.right)
            }
            .pickerStyle(.menu)
            .fixedSize()
            .padding(.bottom, 18)
            Text("Shortcuts")
                .font(.title)
                .padding(.bottom, 18)
            KeyboardShortcuts.Recorder(
                "Open Window:",
                name: .openShelfWindow
            )
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .frame(height: 240)
    }
}

#Preview {
    GeneralView()
}
