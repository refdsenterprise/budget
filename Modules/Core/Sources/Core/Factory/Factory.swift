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
    
    public func makeCategoryScreen() -> any View {
        let router = CategoryRouter(factory: self)
        let presenter = CategoryPresenter(router: router)
        return CategoryScreen(presenter: presenter)
    }
    
    public func makeTransactionScreen(category: CategoryEntity? = nil, date: Date? = nil) -> any View {
        let router = TransactionRouter(factory: self)
        let presenter = TransactionPresenter(router: router, category: category, date: date)
        return TransactionScreen(presenter: presenter)
    }
    
    public func makeAddCategoryScreen(category: CategoryEntity? = nil) -> any View {
        let router = AddCategoryRouter(factory: self)
        let presenter = AddCategoryPresenter(router: router, category: category)
        return AddCategoryScreen(presenter: presenter)
    }
    
    public func makeAddBudgetScreen(newBudget: ((BudgetEntity) -> Void)? = nil) -> any View {
        let presenter = AddBudgetPresenter.instance
        return AddBudgetScreen(presenter: presenter, newBudget: newBudget)
    }
    
    public func makeAddTransactionScreen(transaction: TransactionEntity? = nil) -> any View {
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
    
    public func makeProScreen() -> any View {
        let presenter = ProPresenter()
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
        return CustomizationScree(presenter: presenter)
    }
}
