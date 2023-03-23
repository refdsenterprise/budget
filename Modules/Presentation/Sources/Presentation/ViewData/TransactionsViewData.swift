//
//  TransactionsViewData.swift
//  
//
//  Created by Rafael Santos on 16/03/23.
//

import SwiftUI
import RefdsCore

public final class TransactionsViewData: ObservableObject {
    public static let shared = TransactionsViewData()
    
    @Published public var transactions: [TransactionViewData] = []
    @Published public var value: TransactionValueViewData = .init(value: 0, amount: 0)
    @Published public var chartData: [TransactionChartViewData] = []
}

public struct TransactionValueViewData: DomainModel {
    public var value: Double
    public var amount: Int
}

public struct TransactionViewData: DomainModel {
    public var id: UUID
    public var date: Date
    public var description: String
    public var categoryName: String
    public var categoryColor: Color
    public var amount: Double
}

public struct TransactionChartViewData: DomainModel {
    public var date: Date
    public var value: Double
}
