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
    @State private var isPresented: Bool = false
    private let factory: FactoryProtocol
    
    public init(factory: FactoryProtocol) {
        self.factory = factory
    }
    
    @ViewBuilder
    public func configure(routes: SceneRoutes) -> some View {
        switch routes {
        case .category: AnyView(factory.makeCategoryScreen(isPresentedAddCategory: false, isPresentedAddBudget: false))
        case .budget: AnyView(factory.makeBudgetScreen())
        case .transactions: AnyView(factory.makeTransactionScreen(category: nil, date: nil, isPresentedAddTransaction: false))
        case .addTransaction: AnyView(factory.makeTransactionScreen(category: nil, date: nil, isPresentedAddTransaction: true))
        case .addCategory: AnyView(factory.makeCategoryScreen(isPresentedAddCategory: true, isPresentedAddBudget: false))
        case .settings: AnyView(factory.makeSettingsScreen())
        case .addBudget: AnyView(factory.makeCategoryScreen(isPresentedAddCategory: false, isPresentedAddBudget: true))
        }
    }
}
