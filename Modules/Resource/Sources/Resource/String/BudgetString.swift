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
        case labelBubbleName
        case labelBubbleColor
        case labelPlaceholderName
        case addBubble
        case saveBubble
        
        private var key: String {
            switch self {
            case .navigationTitle: return "budget.navigationTitle"
            case .options: return "budget.options"
            case .amountTransactionsMoment: return "budget.amountTransactionsMoment"
            case .transactionsForCategory: return "budget.transactionsForCategory"
            case .budgetVsActual: return "budget.budgetVsActual"
            case .transactions: return "budget.transactions"
            case .filterByDate: return "budget.filterByDate"
            case .currentValue: return "budget.currentValue"
            case .diff: return "budget.diff"
            case .totalDiff: return "budget.totalDiff"
            case .category: return "budget.category"
            case .value: return "budget.value"
            case .budget: return "budget.budget"
            case .current: return "budget.current"
            case .noDescription: return "budget.noDescription"
            case .biggerBuy: return "budget.biggerBuy"
            case .maxTransactionTitle: return "budget.maxTransactionTitle"
            case .maxTransactionDescription: return "budget.maxTransactionDescription"
            case .maxTransactionHeader: return "budget.maxTransactionHeader"
            case .maxTransactionRanking: return "budget.maxTransactionRanking"
            case .showTransactoins: return "budget.showTransactoins"
            case .concentrationValue: return "budget.concentrationValue"
            case .expansesConcentration: return "budget.expansesConcentration"
            case .labelBubbleName: return "budget.labelBubbleName"
            case .labelBubbleColor: return "budget.labelBubbleColor"
            case .labelPlaceholderName: return "budget.labelPlaceholderName"
            case .addBubble: return "budget.addBubble"
            case .saveBubble: return "budget.saveBubble"
            }
        }
        
        public var value: String {
            switch self {
            case .navigationTitle(let value): return String(format: NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: ""), value)
            case .currentValue(let value): return String(format: NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: ""), value)
            case .maxTransactionRanking(let amount): return String(format: NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: ""), amount)
            default: return NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: "")
            }
        }
    }
}
