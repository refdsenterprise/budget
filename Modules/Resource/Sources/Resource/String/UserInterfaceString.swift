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
        case ok
        case currentValue
        case edit
        case remove
        case week
        case day
        case month
        case year
        case categories
        case home
        case transactions
        case settings
        
        private var key: String {
            switch self {
            case .periodTitle: return "userInterface.component.periodSelection.title"
            case .ok: return "userInterface.ok"
            case .currentValue: return "userInterface.currentValue"
            case .edit: return "userInterface.edit"
            case .remove: return "userInterface.remove"
            case .week: return "userInterface.week"
            case .day: return "userInterface.day"
            case .month: return "userInterface.month"
            case .year: return "userInterface.year"
            case .categories: return "generalTab.categories"
            case .home: return "generalTab.home"
            case .transactions: return "generalTab.transactions"
            case .settings: return "generalTab.settings"
            }
        }
        
        public var value: String {
            NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: "")
        }
    }
}
