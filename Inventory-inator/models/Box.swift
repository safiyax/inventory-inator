//
//  Box.swift
//  Inventory-inator
//
//  Created by Safiya Hooda on 2024-12-17.
//

import CoreImage.CIFilterBuiltins
import Foundation
import SwiftData
import SwiftUI

@Model
class Box {
    var uuid: UUID = UUID()
    var contents: String = ""
    var location: String = ""
    var createdDate: Date = Date.now
    
    init(contents: String, location: String, createdDate: Date) {
        self.contents = contents
        self.location = location
        self.createdDate = createdDate
    }
    
    func deeplink() -> String {
        return "inventory-inator://open-box?uuid=\(uuid.uuidString)"
    }
    
    func qrcode() -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(deeplink().utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
