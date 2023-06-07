//
//  Factory.swift
//  Core
//
//  Created by Rafael Santos on 25/02/23.
//

import SwiftUI
import Domain
import UserInterface
import Presentation

public final class Factory: FactoryProtocol {
    public static let shared = Factory()
    
    public func makeSceneScreen() -> any View {
        let router = SceneRouter(factory: self)
        let presenter = ScenePresenter(router: router)
        return SceneScreen(presenter: presenter)
    }
    
    public func makeCategoryScreen() -> any View {
        let router = CategoryRouter(factory: self)
        let presenter = CategoryPresenter(router: router)
        return CategoryScreen(presenter: presenter)
    }
    
    public func makeTransactionScreen(category: UUID? = nil, date: Date? = nil) -> any View {
        let router = TransactionRouter(factory: self)
        let presenter = TransactionPresenter(router: router, category: category, date: date)
        return TransactionScreen(presenter: presenter)
    }
    
    public func makeAddCategoryScreen(category: UUID? = nil) -> any View {
        let router = AddCategoryRouter(factory: self)
        let presenter = AddCategoryPresenter(router: router, category: category)
        return AddCategoryScreen(presenter: presenter)
    }
    
    public func makeAddBudgetScreen(newBudget: ((AddBudgetViewData) -> Void)? = nil, category: UUID? = nil, budget: UUID? = nil) -> any View {
        let router = AddBudgetRouter(factory: self)
        let presenter = AddBudgetPresenter(router: router, category: category, budget: budget)
        return AddBudgetScreen(presenter: presenter, newBudget: newBudget)
    }
    
    public func makeAddTransactionScreen(transaction: UUID? = nil) -> any View {
        let router = AddTransactionRouter(factory: self)
        let presenter = AddTransactionPresenter(router: router, transaction: transaction)
        return AddTransactionScreen(presenter: presenter)
    }
    
    public func makeBudgetScreen() -> any View {
        let router = BudgetRouter(factory: self)
        let presenter = BudgetPresenter(router: router)
        return BudgetScreen(presenter: presenter)
    }
    
    public func makeSettingsScreen() -> any View {
        let router = SettingsRouter(factory: self)
        let presenter = SettingsPresenter(router: router)
        return SettingsScreen(presenter: presenter)
    }
    
    @MainActor public func makeProScreen() -> any View {
        let presenter = ProPresenter.shared
        return ProScreen(presenter: presenter)
    }
    
    public func makeAboutScreen() -> any View {
        let presenter = AboutPresenter()
        return AboutScreen(presenter: presenter)
    }
    
    public func makeNotificationScreen() -> any View {
        let presenter = NotificationManagerPresenter()
        return NotificationScreen(presenter: presenter)
    }
    
    public func makeCustomizationScreen() -> any View {
        let presenter = CustomizationPresenter()
        return CustomizationScreen(presenter: presenter)
    }
    
    public func makeCustomAppIconScreen() -> any View {
        let presenter = CustomAppIconPresenter()
        return CustomAppIconScreen(presenter: presenter)
    }
}
