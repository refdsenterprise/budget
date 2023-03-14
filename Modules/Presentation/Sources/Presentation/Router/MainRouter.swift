//
//  MainRouter.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import SwiftUI
import Domain

public enum MainRoutes {
    case category
    case budget
    case transactions
    case addTransaction
    case addCategory
}

public struct MainRouter {
    private let factory: FactoryProtocol
    
    public init(factory: FactoryProtocol) {
        self.factory = factory
    }
    
    @ViewBuilder
    public func configure(routes: MainRoutes) -> some View {
        switch routes {
        case .category: AnyView(factory.makeCategoryScreen())
        case .budget: AnyView(factory.makeBudgetScreen())
        case .transactions: AnyView(factory.makeTransactionScreen(category: nil, date: nil))
        case .addTransaction: AnyView(factory.makeAddTransactionScreen(transaction: nil))
        case .addCategory: AnyView(factory.makeAddCategoryScreen(category: nil))
        }
    }
}
