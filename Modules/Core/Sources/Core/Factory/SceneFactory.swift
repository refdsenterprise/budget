//
//  SceneFactory.swift
//  Core
//
//  Created by Rafael Santos on 25/02/23.
//

import Foundation
import Domain
import Category
import Transaction
import Budget

public final class SceneFactory {
    public static let shared = SceneFactory()
    
    public func makeCategoryScene() -> CategoryScene {
        CategoryScene { category, date in
            self.makeTransactionScene(category: category, date: date)
        }
    }
    
    public func makeTransactionScene(category: CategoryEntity, date: Date) -> TransactionScene {
        TransactionScene(category: category, date: date) {
            self.makeAddCategoryScene()
        }
    }
    
    public func makeTransactionScene() -> TransactionScene {
        TransactionScene {
            self.makeAddCategoryScene()
        }
    }
    
    public func makeAddCategoryScene() -> AddCategoryScene {
        AddCategoryScene()
    }
    
    public func makeBudgetScene() -> BudgetScene {
        BudgetScene { category, date in
            self.makeTransactionScene(category: category, date: date)
        }
    }
}
