//
//  BudgetError.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import Foundation

public enum BudgetError: Error {
    case existingCategory
    case notFoundCategory
    case notFoundBudget
    case existingTransaction
    case notFoundTransaction
    case cantDeleteCategory
    case cantDeleteBudget
}
