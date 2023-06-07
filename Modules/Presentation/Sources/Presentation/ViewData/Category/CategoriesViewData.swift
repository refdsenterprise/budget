//
//  CategoriesViewData.swift
//  
//
//  Created by Rafael Santos on 16/03/23.
//

import SwiftUI
import RefdsUI
import RefdsCore

public struct CategoryViewData {
    public var budgets: [Budget] = []
    public var value: Value = .init(totalActual: 0, totalBudget: 0)
    
    public struct Budget {
        public var id: UUID
        public var color: Color
        public var name: String
        public var percent: String
        public var amountTransactions: Int
        public var budget: Double
        public var date: Date
        public var icon: RefdsIconSymbol
        
        public init(id: UUID = .init(), color: Color, name: String = "Any name", percent: String = "00.00%", amountTransactions: Int = .random(in: 1...100), budget: Double = .random(in: 500...2000), date: Date = .current, icon: RefdsIconSymbol = .dollarsign) {
            self.id = id
            self.color = color
            self.name = name
            self.percent = percent
            self.amountTransactions = amountTransactions
            self.budget = budget
            self.date = date
            self.icon = icon
        }
    }
    
    public struct Value {
        public var totalActual: Double
        public var totalBudget: Double
    }
}
