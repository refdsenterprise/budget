//
//  UserInterfaceString.swift
//  
//
//  Created by Rafael Santos on 27/02/23.
//

import Foundation

public enum Strings { }

public extension Strings {
    enum UserInterface {
        case periodTitle
        case currencyCode
        case ok
        case currentValue
        case edit
        case remove
        case week
        case day
        case month
        case year
        
        private var key: String {
            switch self {
            case .periodTitle: return "component.periodSelection.title"
            case .currencyCode: return "currency.code"
            case .ok: return "ok"
            case .currentValue: return "currentValue"
            case .edit: return "edit"
            case .remove: return "remove"
            case .week: return "week"
            case .day: return "day"
            case .month: return "month"
            case .year: return "year"
            }
        }
        
        public var value: String {
            NSLocalizedString(key, tableName: "UserInterface", bundle: .module, comment: "")
        }
    }
}
