//
//  CategoryEntity.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import Foundation
import SwiftUI

public struct CategoryEntity: Codable, Identifiable, Hashable {
    public let id: UUID
    public var name: String
    public var color: Color
    public var budgets: [BudgetEntity]
    
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
