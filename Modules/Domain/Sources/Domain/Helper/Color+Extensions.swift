//
//  Color+Extensions.swift
//  
//
//  Created by Rafael Santos on 24/02/23.
//

import Foundation
import SwiftUI
import RefdsUI
 
#if os(iOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#elseif os(macOS)
import AppKit
#endif

extension Color: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hexString = try container.decode(String.self)
        self.init(hex: hexString)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(asHex())
    }
}


