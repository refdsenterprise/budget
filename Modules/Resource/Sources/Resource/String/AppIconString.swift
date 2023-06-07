//
//  AppIconString.swift
//  
//
//  Created by Rafael Santos on 02/06/23.
//

import Foundation

public extension Strings {
    enum AppIcon {
        case `default`
        case light
        case dark
        case system
        case lightSystem
        case darkSystem
        case lgbt
        case alertError
        
        private var key: String {
            switch self {
            case .`default`: return "appIcon.default"
            case .light: return "appIcon.light"
            case .dark: return "appIcon.dark"
            case .system: return "appIcon.system"
            case .lightSystem: return "appIcon.lightSystem"
            case .darkSystem: return "appIcon.darkSystem"
            case .lgbt: return "appIcon.lgbt"
            case .alertError: return "appIcon.alertError"
            }
        }
        
        public var value: String {
            NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: "")
        }
    }
}
