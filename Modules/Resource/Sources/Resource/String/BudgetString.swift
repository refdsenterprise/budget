//
//  BudgetString.swift
//  
//
//  Created by Rafael Santos on 12/03/23.
//

import Foundation

public extension Strings {
    enum Budget {
        case navigationTitle(String)
        case options
        case amountTransactionsMoment
        case transactionsForCategory
        case budgetVsActual
        case transactions
        case filterByDate
        case currentValue(String)
        case diff
        case totalDiff
        case category
        case value
        case budget
        case current
        case noDescription
        case biggerBuy
        case maxTransactionTitle
        case maxTransactionDescription
        case maxTransactionHeader
        case maxTransactionRanking(Int)
        case showTransactoins
        case concentrationValue
        case expansesConcentration
        
        private var key: String {
            switch self {
            case .navigationTitle: return "navigationTitle"
            case .options: return "options"
            case .amountTransactionsMoment: return "amountTransactionsMoment"
            case .transactionsForCategory: return "transactionsForCategory"
            case .budgetVsActual: return "budgetVsActual"
            case .transactions: return "transactions"
            case .filterByDate: return "filterByDate"
            case .currentValue: return "currentValue"
            case .diff: return "diff"
            case .totalDiff: return "totalDiff"
            case .category: return "category"
            case .value: return "value"
            case .budget: return "budget"
            case .current: return "current"
            case .noDescription: return "noDescription"
            case .biggerBuy: return "biggerBuy"
            case .maxTransactionTitle: return "maxTransactionTitle"
            case .maxTransactionDescription: return "maxTransactionDescription"
            case .maxTransactionHeader: return "maxTransactionHeader"
            case .maxTransactionRanking: return "maxTransactionRanking"
            case .showTransactoins: return "showTransactoins"
            case .concentrationValue: return "concentrationValue"
            case .expansesConcentration: return "expansesConcentration"
            }
        }
        
        public var value: String {
            switch self {
            case .navigationTitle(let value): return String(format: NSLocalizedString(key, tableName: "Budget", bundle: .module, comment: ""), value)
            case .currentValue(let value): return String(format: NSLocalizedString(key, tableName: "Budget", bundle: .module, comment: ""), value)
            case .maxTransactionRanking(let amount): return String(format: NSLocalizedString(key, tableName: "Budget", bundle: .module, comment: ""), amount)
            default: return NSLocalizedString(key, tableName: "Budget", bundle: .module, comment: "")
            }
        }
    }
}
