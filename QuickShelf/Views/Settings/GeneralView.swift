//
//  GeneralView.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/31.
//

import SwiftUI
import KeyboardShortcuts

struct GeneralView: View {
    var body: some View {
        VStack(alignment: .leading) {
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
        .frame(height: 120)
    }
}

#Preview {
    GeneralView()
}
