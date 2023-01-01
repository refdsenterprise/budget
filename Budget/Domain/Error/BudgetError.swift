//
//  BudgetError.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import Foundation

enum BudgetError: Error {
    case existingCategory
    case notFoundCategory
    case notFoundBudget
    
    case existingTransaction
    case notFoundTransaction
}
