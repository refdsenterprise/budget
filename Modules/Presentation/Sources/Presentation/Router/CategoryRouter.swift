//
//  CategoryRouter.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import SwiftUI
import Domain

public enum CategoryRoutes {
    case addCategory(UUID?)
    case addBudget
    case transactions(UUID, Date)
}

public struct CategoryRouter {
    private let factory: FactoryProtocol
    
    public init(factory: FactoryProtocol) {
        self.factory = factory
    }
    
    @ViewBuilder
    public func configure(routes: CategoryRoutes) -> some View {
        switch routes {
        case .addCategory(let category): AnyView(factory.makeAddCategoryScreen(category: category))
        case .addBudget: AnyView(factory.makeAddBudgetScreen(newBudget: nil, category: nil, budget: nil))
        case .transactions(let category, let date): AnyView(factory.makeTransactionScreen(category: category, date: date))
        }
    }
}
