//
//  TransactionEntity.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import Foundation

public struct TransactionEntity: Codable, Identifiable, Hashable {
    public let id: UUID
    public var date: Date
    public var description: String
    public var categoryUUID: UUID
    public var amount: Double
    
    public init(
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
