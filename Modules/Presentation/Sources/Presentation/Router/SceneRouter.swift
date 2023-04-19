//
//  SceneRouter.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import SwiftUI
import Domain

public enum SceneRoutes {
    case category
    case budget
    case transactions
    case addTransaction
    case addCategory
    case addBudget
    case settings
}

public struct SceneRouter {
    private let factory: FactoryProtocol
    
    public init(factory: FactoryProtocol) {
        self.factory = factory
    }
    
    @ViewBuilder
    public func configure(routes: SceneRoutes) -> some View {
        switch routes {
        case .category: AnyView(factory.makeCategoryScreen())
        case .budget: AnyView(factory.makeBudgetScreen())
        case .transactions: AnyView(factory.makeTransactionScreen(category: nil, date: nil))
        case .addTransaction: AnyView(factory.makeAddTransactionScreen(transaction: nil))
        case .addCategory: AnyView(factory.makeAddCategoryScreen(category: nil))
        case .settings: AnyView(factory.makeSettingsScreen())
        case .addBudget: AnyView(factory.makeAddBudgetScreen(newBudget: nil, id: nil))
        }
    }
}
