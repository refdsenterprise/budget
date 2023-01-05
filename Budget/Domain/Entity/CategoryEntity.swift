//
//  CategoryEntity.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import Foundation
import SwiftUI

struct CategoryEntity: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var color: Color
    var budgets: [BudgetEntity]
    
    public init(
        id: UUID = UUID(),
        name: String,
        color: Color,
        budgets: [BudgetEntity]
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.budgets = budgets
    }
}
