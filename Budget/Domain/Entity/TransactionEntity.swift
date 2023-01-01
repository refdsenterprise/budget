//
//  TransactionEntity.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import Foundation

struct TransactionEntity: Codable, Identifiable, Hashable {
    let id: UUID
    var date: Date
    var description: String
    var category: CategoryEntity
    var amount: Double
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        description: String,
        category: CategoryEntity,
        amount: Double
    ) {
        self.id = id
        self.date = date
        self.description = description
        self.category = category
        self.amount = amount
    }
}
