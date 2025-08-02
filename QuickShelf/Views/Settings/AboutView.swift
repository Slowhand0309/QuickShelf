//
//  AboutView.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/31.
//

import SwiftUI
import AppKit

struct AboutView: View {
    private let icon = NSApplication.shared.applicationIconImage

    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            Image(nsImage: icon!)
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .frame(width: 96, height: 96)
                 .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                 .shadow(radius: 6)

             VStack(alignment: .leading, spacing: 6) {
                 Text(Bundle.main.displayName)
                     .font(.title)
                     .fontWeight(.semibold)

                 Text("Version \(Bundle.main.fullVersion)")
                     .font(.subheadline)
                     .foregroundStyle(.secondary)

                 Text("© \(String(Calendar.current.component(.year, from: Date()))) SlowLab. All rights reserved.")
                     .font(.footnote)
                     .foregroundStyle(.secondary)
             }
             Spacer()
         }
         .padding(32)
         .frame(minWidth: 420, minHeight: 180)
    }
}

#Preview {
    AboutView()
}
