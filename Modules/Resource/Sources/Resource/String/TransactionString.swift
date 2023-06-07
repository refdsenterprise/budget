//
//  TransactionString.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import Foundation

// MARK: - Add Transaction
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
            default: return NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: "")
            }
        }
    }
}

// MARK: - Transaction
public extension Strings {
    enum Transaction {
        case navigationTitle
        case searchForTransactions
        case chart
        case totalTransactions
        case options
        case filterPerDate
        case period
        case noDescription
        case chartDate
        case chartValue
        case edit
        case remove
        
        private var key: String {
            switch self {
            case .navigationTitle: return "transaction.navigationTitle"
            case .searchForTransactions: return "transaction.searchForTransactions"
            case .chart: return "transaction.chart"
            case .totalTransactions: return "transaction.totalTransactions"
            case .options: return "transaction.options"
            case .filterPerDate: return "transaction.filterPerDate"
            case .period: return "transaction.period"
            case .noDescription: return "transaction.noDescription"
            case .chartDate: return "transaction.chartDate"
            case .chartValue: return "transaction.chartValue"
            default: return ""
            }
        }
        
        public var value: String {
            switch self {
            case .edit: return Strings.UserInterface.edit.value
            case .remove: return Strings.UserInterface.remove.value
            default: return NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: "")
            }
        }
    }
}
