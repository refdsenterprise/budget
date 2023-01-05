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
    private var categoriesByUUID: [UUID: CategoryEntity] = [:]
    
    private init() { updateCategoriesByUUID() }
    
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
    
    func addCategory(name: String, color: Color, budgets: [BudgetEntity] = []) throws {
        guard categories.contains(where: {
            $0.name.lowercased() == name.lowercased()
        }) == false else { throw BudgetError.existingCategory }
        categories.append(.init(name: name, color: color, budgets: budgets))
        categories.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
        updateCategoriesByUUID()
    }
    
    func editCategory(_ current: CategoryEntity, name: String, color: Color, budgets: [BudgetEntity]) throws {
        guard let index = categories.firstIndex(where: {
            $0 == current
        }) else { throw BudgetError.notFoundCategory }
        categories[index].name = name
        categories[index].budgets = budgets
        categories[index].color = color
        categoriesByUUID[current.id] = categories[index]
    }
    
    func removeCategory(_ current: CategoryEntity) throws {
        guard let index = categories.firstIndex(where: {
            $0 == current
        }) else { throw BudgetError.notFoundCategory }
        categories.remove(at: index)
        updateCategoriesByUUID()
    }
    
    func replaceAllCategories(_ data: Data?) {
        guard let data = data,
              let categories = try? JSONDecoder().decode([CategoryEntity].self, from: data) else {
            return
        }
        self.categories = categories
        self.categories.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
        updateCategoriesByUUID()
    }
    
    func getCategory(by id: UUID) -> CategoryEntity? {
        categoriesByUUID[id]
    }
    
    func updateCategoriesByUUID() {
        categoriesByUUID = [:]
        categories.forEach { category in
            categoriesByUUID[category.id] = category
        }
    }
}
