//
//  CategoryStorage.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsCore
import Domain

public final class CategoryStorage {
    public static let shared =  CategoryStorage()
    @AppStorage("categories") private var categories = [CategoryEntity]()
    private var categoriesByUUID: [UUID: CategoryEntity] = [:]
    
    private init() { updateCategoriesByUUID() }
    
    public func getAllCategories() -> [CategoryEntity] { categories }
    
    public func getCategories(from date: Date = Date(), format: String.DateFormat = .monthYear) -> [CategoryEntity] {
        return categories.filter { category in
            return category.budgets.contains { budget in
                let budgetDate = budget.date.asString(withDateFormat: format)
                let filterDate = date.asString(withDateFormat: format)
                return budgetDate == filterDate
            }
        }
    }
    
    public func getBudget(on category: CategoryEntity, from date: Date = Date(), format: String.DateFormat = .monthYear) throws -> BudgetEntity {
        guard let budget = category.budgets.first(where: {
            let budgetDate = $0.date.asString(withDateFormat: format)
            let filterDate = date.asString(withDateFormat: format)
            return budgetDate == filterDate
        }) else { throw BudgetError.notFoundBudget }
        return budget
    }
    
    public func addCategory(name: String, color: Color, budgets: [BudgetEntity] = []) throws {
        guard categories.contains(where: {
            $0.name.lowercased() == name.lowercased()
        }) == false else { throw BudgetError.existingCategory }
        categories.append(.init(name: name, color: color, budgets: budgets))
        categories.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
        updateCategoriesByUUID()
    }
    
    public func editCategory(_ current: CategoryEntity, name: String, color: Color, budgets: [BudgetEntity]) throws {
        guard let index = categories.firstIndex(where: {
            $0 == current
        }) else { throw BudgetError.notFoundCategory }
        categories[index].name = name
        categories[index].budgets = budgets
        categories[index].color = color
        categoriesByUUID[current.id] = categories[index]
    }
    
    public func removeCategory(_ current: CategoryEntity) throws {
        guard let index = categories.firstIndex(where: {
            $0 == current
        }) else { throw BudgetError.notFoundCategory }
        categories.remove(at: index)
        updateCategoriesByUUID()
    }
    
    public func replaceAllCategories(_ data: Data?) {
        guard let data = data,
              let categories = try? JSONDecoder().decode([CategoryEntity].self, from: data) else {
            return
        }
        self.categories = categories
        self.categories.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
        updateCategoriesByUUID()
    }
    
    public func getCategory(by id: UUID) -> CategoryEntity? {
        categoriesByUUID[id]
    }
    
    public func updateCategoriesByUUID() {
        categoriesByUUID = [:]
        categories.forEach { category in
            categoriesByUUID[category.id] = category
        }
    }
}
