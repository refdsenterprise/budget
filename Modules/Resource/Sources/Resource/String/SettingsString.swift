//
//  SettingsString.swift
//  
//
//  Created by Rafael Santos on 28/03/23.
//

import Foundation

public extension Strings {
    enum Settings {
        case navigationTitle
        case manageNotification
        case manageCustomization
        case aboutApplication
        case headerConfiguration
        case optionPro
        case addTransaction
        case addCategory
        case addBudget
        case headerShortcut
        
        private var key: String {
            switch self {
            case .navigationTitle: return "navigationTitle"
            case .manageNotification: return "manageNotification"
            case .manageCustomization: return "manageCustomization"
            case .aboutApplication: return "aboutApplication"
            case .headerConfiguration: return "headerConfiguration"
            case .optionPro: return "optionPro"
            case .addTransaction: return "addTransaction"
            case .addCategory: return "addCategory"
            case .addBudget: return "addBudget"
            case .headerShortcut: return "headerShortcut"
            }
        }
        
        public var value: String {
            switch self {
            default: return NSLocalizedString(key, tableName: "Settings", bundle: .module, comment: "")
            }
        }
    }
}
