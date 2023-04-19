//
//  SceneString.swift
//  
//
//  Created by Rafael Santos on 18/04/23.
//

import Foundation

public extension Strings {
    enum Scene {
        case navigationTitle
        case headerShowing
        case headerCreation
        case labelAddTransaction
        case labelAddCategory
        case labelAddBudget
        
        private var key: String {
            switch self {
            case .navigationTitle: return "navigationTitle"
            case .headerShowing: return "headerShowing"
            case .headerCreation: return "headerCreation"
            case .labelAddTransaction: return "labelAddTransaction"
            case .labelAddCategory: return "labelAddCategory"
            case .labelAddBudget: return "labelAddBudget"
            }
        }
        
        public var value: String {
            switch self {
            default: return NSLocalizedString(key, tableName: "Scene", bundle: .module, comment: "")
            }
        }
    }
}
