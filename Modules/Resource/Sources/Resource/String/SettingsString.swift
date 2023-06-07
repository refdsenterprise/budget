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
        case faceIDPasscode
        case customAppIcon
        case sytemPermissions
        
        private var key: String {
            switch self {
            case .navigationTitle: return "settings.navigationTitle"
            case .manageNotification: return "settings.manageNotification"
            case .manageCustomization: return "settings.manageCustomization"
            case .aboutApplication: return "settings.aboutApplication"
            case .headerConfiguration: return "settings.headerConfiguration"
            case .optionPro: return "settings.optionPro"
            case .addTransaction: return "settings.addTransaction"
            case .addCategory: return "settings.addCategory"
            case .addBudget: return "settings.addBudget"
            case .headerShortcut: return "settings.headerShortcut"
            case .faceIDPasscode: return "settings.faceIDPasscode"
            case .customAppIcon: return "settings.customAppIcon"
            case .sytemPermissions: return "settings.permissions"
            }
        }
        
        public var value: String {
            switch self {
            default: return NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: "")
            }
        }
    }
}
