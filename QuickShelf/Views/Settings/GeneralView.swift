//
//  GeneralView.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/31.
//

import SwiftUI
import KeyboardShortcuts
import LaunchAtLogin

struct GeneralView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("General")
                .font(.title)
                .padding(.bottom, 18)
            LaunchAtLogin.Toggle()
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
