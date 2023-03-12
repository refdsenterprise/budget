//
//  File.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import Foundation

public extension Strings {
    enum AddTransaction {
        case navigationTitle
        case dateAndTime
        case inputMonth
        case description
        case inputDescription
        case category
        case addNewCategory
        
        private var key: String {
            switch self {
            case .navigationTitle: return "addTransaction.navigationTitle"
            case .dateAndTime: return "addTransaction.dateAndTime"
            case .inputMonth: return "addTransaction.inputMonth"
            case .description: return "addTransaction.description"
            case .inputDescription: return "addTransaction.inputDescription"
            case .category: return "addTransaction.category"
            case .addNewCategory: return "addTransaction.addNewCategory"
            }
        }
        
        public var value: String {
            switch self {
            default: return NSLocalizedString(key, tableName: "Transaction", bundle: .module, comment: "")
            }
        }
    }
}
