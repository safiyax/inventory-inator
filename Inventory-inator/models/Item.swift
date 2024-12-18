//
//  Item.swift
//  Inventory-inator
//
//  Created by Safiya Hooda on 2024-12-17.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date = Date.now
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
