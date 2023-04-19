//
//  CategoriesViewData.swift
//  
//
//  Created by Rafael Santos on 16/03/23.
//

import SwiftUI
import RefdsCore

public struct CategoryViewData {
    public var budgets: [Budget] = []
    public var value: Value = .init(totalActual: 0, totalBudget: 0)
    
    public struct Budget: DomainModel {
        public var id: UUID
        public var color: Color
        public var name: String
        public var percent: String
        public var amountTransactions: Int
        public var budget: Double
    }
    
    public struct Value: DomainModel {
        public var totalActual: Double
        public var totalBudget: Double
    }
}
