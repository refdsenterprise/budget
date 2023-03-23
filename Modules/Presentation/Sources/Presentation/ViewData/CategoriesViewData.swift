//
//  CategoriesViewData.swift
//  
//
//  Created by Rafael Santos on 16/03/23.
//

import SwiftUI
import RefdsCore

public final class CategoriesViewData: ObservableObject {
    public static let shared = CategoriesViewData()
    
    @Published public var budgets: [CategoryViewData] = []
    @Published public var value: CategoryValueViewData = .init(totalActual: 0, totalBudget: 0)
}

public struct CategoryValueViewData: DomainModel {
    public var totalActual: Double
    public var totalBudget: Double
}

public struct CategoryViewData: DomainModel {
    public var id: UUID
    public var color: Color
    public var name: String
    public var percent: Double
    public var amountTransactions: Int
    public var totalActual: Double
}
