//
//  ContentView.swift
//  Inventory-inator
//
//  Created by Safiya Hooda on 2024-12-17.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @Query private var boxes: [Box]
    @State private var path = [Box]()
    @State private var selection = Set<Box>()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(boxes) { box in
                    NavigationLink(value: box) {
                        BoxItemView(box: box)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Boxes")
            .navigationDestination(for: Box.self) {box in
                EditBoxView(box: box)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .onOpenURL(perform: { url in
                print("App was opened via URL: \(url)")
                handleIncomingURL(url)
            })
        }
    }
    
    private func handleIncomingURL(_ url: URL) {
        guard url.scheme == "inventory-inator" else {
            return
        }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL")
            return
        }
        guard let action = components.host, action == "open-box" else {
            print("Unknown URL, we can't handle this one!")
            return
        }
        guard let boxUUID = components.queryItems?.first(where: { $0.name == "uuid" })?.value else {
            print("Box UUID not found")
            return
        }
        guard let box = boxes.first(where: {$0.uuid.uuidString == boxUUID}) else {
            print("No Box with \(boxUUID)")
            return
        }
        path = [box]
    }

    private func addItem() {
        withAnimation {
            let newBox = Box(contents: "", location: "", createdDate: .now)
            modelContext.insert(newBox)
            path = [newBox]
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(boxes[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Box.self, inMemory: true)
}
