//
//  BudgetViewData.swift
//  
//
//  Created by Rafael Santos on 16/03/23.
//

import SwiftUI
import RefdsCore

public final class BudgetViewData: ObservableObject {
    public static let shared = BudgetViewData()
    
    @Published public var remainingCategory: [RemainingCategoryViewData] = []
    @Published public var remainingValue: RemainingValueViewData = .init(amount: 0, percent: 0)
    @Published public var amountTransactionView: Int = 0
    @Published public var chartData: [BudgetChartViewData] = []
    @Published public var biggerBuy: TransactionViewData?
    @Published public var weekdays: [String] = []
    @Published public var weekdaysDetail: [BudgetWeekdayDetailViewData] = []
    @Published public var weekdayTransactions: [TransactionViewData] = []
}

public struct RemainingCategoryViewData: DomainModel {
    public var categoryName: String
    public var remainingValue: Double
    public var remainingPercent: Double
    public var percentColor: Color
}

public struct RemainingValueViewData: DomainModel {
    public var amount: Double
    public var percent: Double
}

public struct BudgetChartViewData: DomainModel {
    public var label: String
    public var data: [ChartData]
    
    public struct ChartData: DomainModel {
        public var category: String
        public var value: Double
    }
}

public struct BudgetWeekdayDetailViewData: DomainModel {
    public var position: Int
    public var amount: Double
    public var percent: Double
    public var amountTransactions: Double
}
