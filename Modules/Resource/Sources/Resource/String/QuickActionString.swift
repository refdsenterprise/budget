//
//  QuickActionString.swift
//
//
//  Created by Rafael Santos on 06/06/23.
//

import Foundation

public extension Strings {
    enum QuickAction {
        case addTransaction
        case addBudget
        case addCategory
        
        private var key: String {
            switch self {
            case .addTransaction: return "quickAction.addTransaction"
            case .addBudget: return "quickAction.addBudget"
            case .addCategory: return "quickAction.addCategory"
            }
        }
        
        public var value: String {
            switch self {
            default: return NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: "")
            }
        }
        
        public var actionType: String {
            switch self {
            case .addTransaction: return "addTransaction"
            case .addBudget: return "addBudget"
            case .addCategory: return "addCategory"
            }
        }
    }
}
