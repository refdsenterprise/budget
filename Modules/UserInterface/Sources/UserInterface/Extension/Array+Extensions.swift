//
//  Array+Extensions.swift
//  
//
//  Created by Rafael Santos on 25/02/23.
//

import Foundation
import SwiftUI

public extension Array where Element == GridItem {
    static func columns(width: CGFloat, maxAmount: Int? = nil) -> Self {
        var columnsAmount = Int(width / 350)
        if let maxAmount = maxAmount { columnsAmount = columnsAmount > maxAmount ? maxAmount : columnsAmount }
        return (0 ..< columnsAmount).map { _ in GridItem(.flexible()) }
    }
}
