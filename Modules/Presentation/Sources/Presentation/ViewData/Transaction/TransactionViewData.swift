//
//  TransactionsViewData.swift
//  
//
//  Created by Rafael Santos on 16/03/23.
//

import SwiftUI
import RefdsCore

public struct TransactionViewData {
    public var value: Value = .init(value: 0, amount: 0)
    public var transactions: [Transaction] = []
    public var chart: [Chart] = []
    
    public struct Value: DomainModel {
        public var value: Double
        public var amount: Int
    }
    
    public struct Transaction {
        public var id: UUID
        public var date: Date
        public var description: String
        public var categoryName: String
        public var categoryColor: Color
        public var amount: Double
    }
    
    public struct Chart: DomainModel {
        public var date: Date
        public var value: Double
    }
}
