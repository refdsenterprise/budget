//
//  UserInterfaceString.swift
//  
//
//  Created by Rafael Santos on 27/02/23.
//

import Foundation

// MARK: - User Interface
public extension Strings {
    enum UserInterface {
        case periodTitle
        case currencyCode
        case ok
        
        private var key: String {
            switch self {
            case .periodTitle: return "component.periodSelection.title"
            case .currencyCode: return "currency.code"
            case .ok: return "ok"
            }
        }
        
        public var value: String {
            NSLocalizedString(key, tableName: "UserInterface", bundle: .module, comment: "")
        }
    }
}
