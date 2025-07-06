//
//  ContentView.swift
//  QuickShelf
//
//  Created by slowhand on 2025/07/04.
//

import SwiftUI

struct ContentView: View {
    @State var inputDir = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Directory")
            HStack {
                TextField("Please select directory", text: $inputDir)
                    .disabled(true)
                Button {
                    // TODO
                } label: {
                    Image(systemName: "folder")
                }
            }
            Text("Items")
            List {
                ForEach(1...20, id: \.self) { index in
                    Text("Folder\(index)")
                }
            }
            .frame(height: 300)
            .scrollContentBackground(.hidden)
            .background(Color.black.opacity(0.3))
        }
        .padding(.all, 16)
    }
}

#Preview {
    ContentView()
}
