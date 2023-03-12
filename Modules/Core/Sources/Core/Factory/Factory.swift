//
//  Factory.swift
//  Core
//
//  Created by Rafael Santos on 25/02/23.
//

import Foundation
import Domain
import Category
import Transaction
import Budget
import UserInterface
import Presentation
import SwiftUI

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
    
    public func makeBudgetScene() -> any View {
        BudgetScene { category, date in
            self.makeTransactionScreen(category: category, date: date)
        }
    }
}
