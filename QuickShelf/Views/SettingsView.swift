//
//  SettingsView.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/31.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralView()
            .tabItem {
                Label("General", systemImage: "gearshape.fill")
            }
            AboutView()
            .tabItem {
                Label("About", systemImage: "person.crop.circle")
            }
        }
        .frame(width: 500)
    }
}

#Preview {
    SettingsView()
}
