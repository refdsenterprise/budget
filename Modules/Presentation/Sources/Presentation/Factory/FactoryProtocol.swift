//
//  FactoryProtocol.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import Foundation
import Domain
import UserInterface
import SwiftUI

public protocol FactoryProtocol {
    func makeCategoryScreen() -> any View
    func makeTransactionScene(category: CategoryEntity, date: Date) -> any View
    func makeTransactionScene() -> any View
    func makeAddCategoryScreen(category: CategoryEntity?) -> any View
    func makeAddBudgetScreen(newBudget: ((BudgetEntity) -> Void)?) -> any View
    func makeBudgetScene() -> any View
}
