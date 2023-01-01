//
//  BudgetEntity.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import Foundation

struct BudgetEntity: Codable, Identifiable, Hashable {
    let id: UUID
    let date: Date
    var amount: Double
    
    init(id: UUID = UUID(), date: Date = Date(), amount: Double) {
        self.id = id
        self.date = date
        self.amount = amount
    }
}
