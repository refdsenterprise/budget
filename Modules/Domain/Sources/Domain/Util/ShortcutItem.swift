//
//  ShortcutItem.swift
//  
//
//  Created by Rafael Santos on 22/05/23.
//

import Foundation

public enum ShortcutItem: String, Identifiable {
    public var id: String { self.rawValue }
    
    case addCategory
    case addTransaction
    case addBudget
    
    public var tabItem: TabItem {
        switch self {
        case .addBudget, .addCategory: return .category
        case .addTransaction: return .transaction
        }
    }
}
