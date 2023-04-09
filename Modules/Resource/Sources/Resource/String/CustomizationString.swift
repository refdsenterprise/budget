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
            case .navigationTitle: return "navigationTitle"
            case .color: return "color"
            case .appearence: return "appearence"
            case .theme: return "theme"
            case .appName: return "appName"
            case .auto: return "auto"
            case .light: return "light"
            case .dark: return "dark"
            }
        }
        
        public var value: String {
            return NSLocalizedString(key, tableName: "Customization", bundle: .module, comment: "")
        }
    }
}
