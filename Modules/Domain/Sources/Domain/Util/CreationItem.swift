//
//  CreationItem.swift
//  
//
//  Created by Rafael Santos on 18/04/23.
//

import Foundation
import SwiftUI
import RefdsUI
import Resource

public enum CreationItem: Int, CaseIterable {
    case category = 1
    case budget = 2
    case transaction = 3
    
    public var title: String {
        switch self {
        case .category: return Strings.Scene.labelAddCategory.value
        case .budget: return Strings.Scene.labelAddBudget.value
        case .transaction: return Strings.Scene.labelAddTransaction.value
        }
    }
    
    public var image: Image {
        Image(systemName: RefdsIconSymbol.plusSquareFill.rawValue)
    }
}
