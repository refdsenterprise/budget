//
//  CustomizationString.swift
//  
//
//  Created by Rafael Santos on 09/04/23.
//

import Foundation

public extension Strings {
    enum Customization {
        case navigationTitle
        case color
        case appearence
        case theme
        case appName
        case auto
        case light
        case dark
        
        private var key: String {
            switch self {
            case .navigationTitle: return "customization.navigationTitle"
            case .color: return "customization.color"
            case .appearence: return "customization.appearence"
            case .theme: return "customization.theme"
            case .appName: return "customization.appName"
            case .auto: return "customization.auto"
            case .light: return "customization.light"
            case .dark: return "customization.dark"
            }
        }
        
        public var value: String {
            return NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: "")
        }
    }
}
