//
//  UserInterfaceString.swift
//  
//
//  Created by Rafael Santos on 27/02/23.
//

import Foundation

public enum Strings {
    case addBudget(Strings.AddBudget)
    case addCategory(Strings.AddCategory)
    case category(Strings.Category)
    case addTransaction(Strings.AddTransaction)
    case transaction(Strings.Transaction)
    case budget(Strings.Budget)
    
    static func value(_ string: Strings) -> String {
        switch string {
        case .addBudget(let addBudget): return addBudget.value
        case .addCategory(let addCategory): return addCategory.value
        case .category(let category): return category.value
        case .addTransaction(let addTransaction): return addTransaction.value
        case .transaction(let transaction): return transaction.value
        case .budget(let budget): return budget.value
        }
    }
}

// MARK: - User Interface
public extension Strings {
    enum UserInterface {
        case periodTitle
        case currencyCode
        case ok
        case currentValue
        case edit
        case remove
        
        private var key: String {
            switch self {
            case .periodTitle: return "component.periodSelection.title"
            case .currencyCode: return "currency.code"
            case .ok: return "ok"
            case .currentValue: return "currentValue"
            case .edit: return "edit"
            case .remove: return "remove"
            }
        }
        
        public var value: String {
            NSLocalizedString(key, tableName: "UserInterface", bundle: .module, comment: "")
        }
    }
}
