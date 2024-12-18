//
//  EditBoxView.swift
//  Inventory-inator
//
//  Created by Safiya Hooda on 2024-12-17.
//

import SwiftData
import SwiftUI

struct EditBoxView: View {
    @State private var image: Image?
    @Bindable var box: Box
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    VStack {
                        image?
                            .scaledToFit()
                            .frame(width: 192)
                            .contextMenu(ContextMenu(menuItems: {
                                Button {
                                    saveImage()
                                } label: {
                                    Text("Save QR Code")
                                }
                                Button {
                                    UIPasteboard.general.string = box.deeplink()
                                } label: {
                                    Text("Copy Deeplink")
                                }
                            }))
                        Text(box.deeplink())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .textSelection(.enabled)
                            
                    }
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)
            Section("Details") {
                TextField("Location", text: $box.location)
                TextField("Contents", text: $box.contents)
            }
        }
        .navigationTitle("Edit Box")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            loadImage()
        })
    }
    
    func loadImage() {
        image = Image(uiImage: box.qrcode())
                            .resizable()
                            .interpolation(.none)
    }
    
    @MainActor func saveImage() {
        let renderer = ImageRenderer(content: Image(uiImage: box.qrcode()).resizable().interpolation(.none).frame(width: 512, height: 512))
        if let uiImage = renderer.uiImage {
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Box.self, configurations: config)
        let box = Box(contents: "Boxes and Cables", location: "Master Bedroom", createdDate: .now)
        
        return EditBoxView(box: box)
        .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
