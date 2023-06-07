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
            case .navigationTitle: return "scene.navigationTitle"
            case .headerShowing: return "scene.headerShowing"
            case .headerCreation: return "scene.headerCreation"
            case .labelAddTransaction: return "scene.labelAddTransaction"
            case .labelAddCategory: return "scene.labelAddCategory"
            case .labelAddBudget: return "scene.labelAddBudget"
            }
        }
        
        public var value: String {
            switch self {
            default: return NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: "")
            }
        }
    }
}
