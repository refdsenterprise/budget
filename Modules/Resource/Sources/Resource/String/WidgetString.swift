//
//  WidgetString.swift
//  
//
//  Created by Rafael Santos on 05/06/23.
//

import Foundation

public extension Strings {
    enum Widget {
        case budget
        case noneSmall(String)
        case proSmall
        case noneButton
        case proButton
        case actualValue
        case budgetValue
        case remaining
        case noneMedium(String)
        case proMedium
        case noneLarge(String)
        case proLarge
        case noneButtonLarge
        case proButtonLarge
        case noneRectangular(String)
        case proRectangular
        case value
        case noneInline(String)
        case proInline
        case remainingInline
        case description
        
        private var key: String {
            switch self {
            case .budget: return "widget.budget"
            case .noneSmall: return "widget.noneSmall"
            case .proSmall: return "widget.proSmall"
            case .noneButton: return "widget.noneButton"
            case .proButton: return "widget.proButton"
            case .actualValue: return "widget.actualValue"
            case .budgetValue: return "widget.budgetValue"
            case .remaining: return "widget.remaining"
            case .noneMedium: return "widget.noneMedium"
            case .proMedium: return "widget.proMedium"
            case .noneLarge: return "widget.noneLarge"
            case .proLarge: return "widget.proLarge"
            case .noneButtonLarge: return "widget.noneButtonLarge"
            case .proButtonLarge: return "widget.proButtonLarge"
            case .noneRectangular: return "widget.noneRectangular"
            case .proRectangular: return "widget.proRectangular"
            case .value: return "widget.value"
            case .noneInline: return "widget.noneInline"
            case .proInline: return "widget.proInline"
            case .remainingInline: return "widget.remainingInline"
            case .description: return "widget.description"
            }
        }
        
        public var value: String {
            switch self {
            case .noneSmall(let value): return String(format: NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: ""), value)
            case .noneMedium(let value): return String(format: NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: ""), value)
            case .noneLarge(let value): return String(format: NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: ""), value)
            case .noneRectangular(let value): return String(format: NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: ""), value)
            case .noneInline(let value): return String(format: NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: ""), value)
            default: return NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: "")
            }
        }
    }
}
