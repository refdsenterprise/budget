//
//  BudgetViewData.swift
//  
//
//  Created by Rafael Santos on 16/03/23.
//

import SwiftUI

public struct BudgetViewData {
    public var value: Value = .init(totalActual: 0, totalBudget: 0)
    public var remainingCategory: [RemainingCategory] = []
    public var remainingCategoryValue: RemainingValue = .init(amount: 0, percentString: "0")
    public var amountTransactions: Int = 0
    public var chart: [BudgetChart] = []
    public var biggerBuy: TransactionViewData.Transaction?
    public var weekdays: [String] = []
    public var weekdaysDetail: BudgetWeekdayDetail?
    public var weekdayTransactions: [TransactionViewData.Transaction] = []
    public var bubbleWords: [Bubble] = []
    
    public struct Value {
        public var totalActual: Double
        public var totalBudget: Double
    }
    
    public struct RemainingCategory {
        public var id: UUID
        public var name: String
        public var value: Double
        public var percent: Double
        public var percentString: String
        public var percentColor: Color
    }
    
    public struct RemainingValue {
        public var amount: Double
        public var percentString: String
        public var color: Color {
            let percentStringFormatted = percentString.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: ",", with: ".")
            let percent = Double(percentStringFormatted) ?? 0
            return percent <= 0 ? .red : percent <= 30 ? .yellow : .green
        }
    }
    
    public struct BudgetChart {
        public var label: String
        public var data: [ChartData]
        
        public struct ChartData {
            public var category: String
            public var value: Double
        }
    }
    
    public struct BudgetWeekdayDetail {
        public var amount: Double
        public var percentString: String
        public var amountTransactions: Int
    }
    
    public struct Bubble: Equatable {
        public var id: UUID
        public var title: String
        public var value: CGFloat
        public var color: Color
        public var offset = CGSize.zero
        public var realValue: Double
    }
}
