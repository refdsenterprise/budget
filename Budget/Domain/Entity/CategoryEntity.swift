//
//  CategoryEntity.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import Foundation

struct CategoryEntity: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var budgets: [BudgetEntity]
    
    public init(
        id: UUID = UUID(),
        name: String,
        budgets: [BudgetEntity]
    ) {
        self.id = id
        self.name = name
        self.budgets = budgets
    }
}
