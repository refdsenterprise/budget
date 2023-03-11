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
    
    public func makeTransactionScene(category: CategoryEntity, date: Date) -> any View {
        TransactionScene(category: category, date: date) {
            self.makeAddCategoryScreen()
        }
    }
    
    public func makeTransactionScene() -> any View {
        TransactionScene {
            self.makeAddCategoryScreen()
        }
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
    
    public func makeBudgetScene() -> any View {
        BudgetScene { category, date in
            self.makeTransactionScene(category: category, date: date)
        }
    }
}
