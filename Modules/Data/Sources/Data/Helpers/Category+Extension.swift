//
//  Category+Extension.swift
//  
//
//  Created by Rafael Santos on 13/04/23.
//

import Foundation
import Domain

public extension CategoryEntity {
    var budgetsValue: [BudgetEntity] {
        Worker.shared.category.getBudgets(in: budgets)
    }
}
