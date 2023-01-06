//
//  AddCategoryPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI
import UniformTypeIdentifiers

final class AddCategoryPresenter: ObservableObject {
    static var instance: Self { Self() }
    
    @Published var name: String = ""
    @Published var color: Color = .accentColor
    @Published var budgets: [BudgetEntity] = []
    private var category: CategoryEntity?
    
    init(category: CategoryEntity? = nil) {
        self.category = category
        if let category = category {
            name = category.name
            budgets = category.budgets
            color = category.color
        }
    }
    
    func existBudget(_ budget: BudgetEntity) -> Bool {
        budgets.contains(where: {
            $0.date.asString(withDateFormat: "MM/yyyy") == budget.date.asString(withDateFormat: "MM/yyyy")
        })
    }
    
    func addBudget(_ budget: BudgetEntity) {
        guard !existBudget(budget) else { return }
        budgets.append(budget)
    }
    
    func addCategory(onSuccess: () -> Void, onError: (BudgetError) -> Void) {
        do {
            try Storage.shared.category.addCategory(name: name, color: color, budgets: budgets)
            onSuccess()
        } catch { onError(error as! BudgetError) }
    }
    
    func editCategory(onSuccess: () -> Void, onError: (BudgetError) -> Void) {
        do {
            try Storage.shared.category.editCategory(category!, name: name, color: color, budgets: budgets)
            onSuccess()
        } catch { onError(error as! BudgetError) }
    }
    
    func removeBudget(_ budget: BudgetEntity) throws {
        guard !Storage.shared.transaction.getAllTransactions().contains(where: { transaction in
            transaction.category?.budgets.contains(where: { $0.id == budget.id }) ?? false
        }) else { throw BudgetError.cantDeleteBudget }
        guard let index = budgets.firstIndex(where: { $0 == budget }) else { return }
        budgets.remove(at: index)
    }
    
    var canAddNewBudget: Bool {
        return !budgets.isEmpty && !name.isEmpty
    }
    
    var buttonBackgroundColor: Color {
        return canAddNewBudget ? .accentColor.opacity(0.2) : .secondary.opacity(0.2)
    }
    
    var buttonForegroundColor: Color {
        return canAddNewBudget ? .accentColor : .secondary
    }
}
