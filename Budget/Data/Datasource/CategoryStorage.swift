//
//  CategoryStorage.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI

final class CategoryStorage {
    static let shared =  CategoryStorage()
    @AppStorage("categories") private var categories = [CategoryEntity]()
    
    func getAllCategories() -> [CategoryEntity] { categories }
    
    func getCategories(from date: Date = Date(), format: String = "MM/yyyy") -> [CategoryEntity] {
        return categories.filter { category in
            return category.budgets.contains { budget in
                let budgetDate = budget.date.asString(withDateFormat: format)
                let filterDate = date.asString(withDateFormat: format)
                return budgetDate == filterDate
            }
        }
    }
    
    func getBudget(on category: CategoryEntity, from date: Date = Date(), format: String = "MM/yyyy") throws -> BudgetEntity {
        guard let budget = category.budgets.first(where: {
            let budgetDate = $0.date.asString(withDateFormat: format)
            let filterDate = date.asString(withDateFormat: format)
            return budgetDate == filterDate
        }) else { throw BudgetError.notFoundBudget }
        return budget
    }
    
    func addCategory(name: String, budgets: [BudgetEntity] = []) throws {
        guard categories.contains(where: {
            $0.name.lowercased() == name.lowercased()
        }) == false else { throw BudgetError.existingCategory }
        categories.append(.init(name: name, budgets: budgets))
    }
    
    func editCategory(_ current: CategoryEntity, name: String, budgets: [BudgetEntity]) throws {
        guard let index = categories.firstIndex(where: {
            $0 == current
        }) else { throw BudgetError.notFoundCategory }
        categories[index].name = name
        categories[index].budgets = budgets
    }
    
    func removeCategory(_ current: CategoryEntity) throws {
        guard let index = categories.firstIndex(where: {
            $0 == current
        }) else { throw BudgetError.notFoundCategory }
        categories.remove(at: index)
    }
}
