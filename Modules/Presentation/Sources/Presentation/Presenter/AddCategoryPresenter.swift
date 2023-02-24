//
//  AddCategoryPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI
import UniformTypeIdentifiers
import Domain
import Data

public final class AddCategoryPresenter: ObservableObject {
    public static var instance: Self { Self() }
    
    @Published public var name: String = ""
    @Published public var color: Color = .accentColor
    @Published public var budgets: [BudgetEntity] = []
    private var category: CategoryEntity?
    
    public init(category: CategoryEntity? = nil) {
        self.category = category
        if let category = category {
            name = category.name
            budgets = category.budgets
            color = category.color
        }
    }
    
    public func existBudget(_ budget: BudgetEntity) -> Bool {
        budgets.contains(where: {
            $0.date.asString(withDateFormat: .monthYear) == budget.date.asString(withDateFormat: .monthYear)
        })
    }
    
    public func addBudget(_ budget: BudgetEntity) {
        guard !existBudget(budget) else { return }
        budgets.append(budget)
    }
    
    public func addCategory(onSuccess: () -> Void, onError: (BudgetError) -> Void) {
        do {
            try Storage.shared.category.addCategory(name: name, color: color, budgets: budgets)
            onSuccess()
        } catch { onError(error as! BudgetError) }
    }
    
    public func editCategory(onSuccess: () -> Void, onError: (BudgetError) -> Void) {
        do {
            try Storage.shared.category.editCategory(category!, name: name, color: color, budgets: budgets)
            onSuccess()
        } catch { onError(error as! BudgetError) }
    }
    
    public func removeBudget(_ budget: BudgetEntity) throws {
        guard !Storage.shared.transaction.getAllTransactions().contains(where: { transaction in
            transaction.category?.budgets.contains(where: { $0.id == budget.id }) ?? false
        }) else { throw BudgetError.cantDeleteBudget }
        guard let index = budgets.firstIndex(where: { $0 == budget }) else { return }
        budgets.remove(at: index)
    }
    
    public var canAddNewBudget: Bool {
        return !budgets.isEmpty && !name.isEmpty
    }
    
    public var buttonBackgroundColor: Color {
        return canAddNewBudget ? .accentColor.opacity(0.2) : .secondary.opacity(0.2)
    }
    
    public var buttonForegroundColor: Color {
        return canAddNewBudget ? .accentColor : .secondary
    }
}
