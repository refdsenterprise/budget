//
//  BudgetEntity.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import Foundation

public struct BudgetEntity: Codable, Identifiable, Hashable {
    public let id: UUID
    public let date: Date
    public var amount: Double
    public var description: String?
    
    public init(id: UUID = UUID(), date: Date = Date(), amount: Double, description: String? = nil) {
        self.id = id
        self.date = date
        self.amount = amount
        self.description = description
    }
}
