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
    var category: CategoryEntity? { Storage.shared.category.getCategory(by: categoryUUID) }
    var categoryUUID: UUID
    var amount: Double
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        description: String,
        categoryUUID: UUID,
        amount: Double
    ) {
        self.id = id
        self.date = date
        self.description = description
        self.categoryUUID = categoryUUID
        self.amount = amount
    }
}
