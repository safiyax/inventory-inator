//
//  BoxItemView.swift
//  Inventory-inator
//
//  Created by Safiya Hooda on 2024-12-17.
//

import SwiftData
import SwiftUI

struct BoxItemView: View {
    @Bindable var box: Box
    
    var body: some View {
        HStack {
            Image(uiImage: box.qrcode())
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .padding(.trailing, 12)
                .selectionDisabled(false)
            VStack(alignment: .leading) {
                Text(box.location)
                    .font(.headline)
                Text(box.contents)
                    .font(.caption)
                    .italic()
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .frame(maxHeight: 80)

    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Box.self, configurations: config)
        let box = Box(contents: "Boxes and Cables", location: "Master Bedroom", createdDate: .now)
        
        return List {
            BoxItemView(box: box)
        }
        .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
