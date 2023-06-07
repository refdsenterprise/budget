//
//  CategoryWorker.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsCore
import Domain
import CoreData

public final class CategoryWorker {
    public static let shared = CategoryWorker()
    private let database = Database.shared
    
    public func getAllCategories() -> [CategoryEntity] {
        let request = CategoryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return (try? database.viewContext.fetch(request)) ?? []
    }
    
    public func getAllBudgets() -> [BudgetEntity] {
        let request = BudgetEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return (try? database.viewContext.fetch(request)) ?? []
    }
    
    public func getCategories(from date: Date = Date()) -> [CategoryEntity] {
        return getAllCategories().filter { category in
            guard let _ = getBudget(on: category.id, from: date) else { return false }
            return true
        }
    }
    
    public func getCategory(by id: UUID) -> CategoryEntity? {
        let request = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        guard let category = try? database.viewContext.fetch(request).first else { return nil }
        return category
    }
    
    public func getBudget(in id: UUID) -> BudgetEntity? {
        let request = BudgetEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        guard let budget = try? database.viewContext.fetch(request).first else { return nil }
        return budget
    }
    
    public func getBudgets(in ids: [UUID]) -> [BudgetEntity] {
        let request = BudgetEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        guard let budgets = try? database.viewContext.fetch(request) else { return [] }
        return budgets.filter({ ids.contains($0.id) })
    }
    
    public func getBudgets(on category: UUID) -> [BudgetEntity] {
        let request = BudgetEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@", category as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        guard let budgets = try? database.viewContext.fetch(request) else { return [] }
        return budgets
    }
    
    public func getBudget(on category: UUID, from date: Date = Date()) -> BudgetEntity? {
        getBudgets(on: category).filter { budget in
            let budgetDate = budget.date.asString(withDateFormat: .monthYear)
            let currentDate = date.asString(withDateFormat: .monthYear)
            return budgetDate == currentDate
        }.first
    }
    
    public func addCategory(id: UUID, name: String, color: Color, budgets: [UUID], icon: String) throws {
        guard let category = getCategory(by: id) else {
            let category = CategoryEntity(context: database.viewContext)
            category.id = id
            category.name = name.uppercased()
            category.color = color.asHex()
            category.budgets = budgets
            try database.viewContext.save()
            return
        }
        category.id = id
        category.name = name.uppercased()
        category.color = color.asHex()
        category.budgets = budgets
        category.icon = icon
        try database.viewContext.save()
    }
    
    public func addBudget(id: UUID, amount: Double, date: Date, message: String?, category: UUID) throws {
        guard let budget = getBudget(in: id) else {
            let budget = BudgetEntity(context: database.viewContext)
            budget.id = id
            budget.amount = amount
            budget.date = date.timestamp
            budget.message = message
            budget.category = category
            try database.viewContext.save()
            return
        }
        budget.id = id
        budget.amount = amount
        budget.date = date.timestamp
        budget.message = message
        budget.category = category
        try database.viewContext.save()
    }
    
    public func removeCategory(id: UUID) throws {
        guard let category = getCategory(by: id) else { throw BudgetError.notFoundCategory }
        getBudgets(on: category.id).forEach { database.viewContext.delete($0) }
        database.viewContext.delete(category)
        try database.viewContext.save()
    }
    
    public func removeBudget(id: UUID) throws {
        guard let budget = getBudget(in: id) else { throw BudgetError.notFoundBudget }
        database.viewContext.delete(budget)
        try database.viewContext.save()
    }
    
    public func replaceAllCategories(_ data: Data?) {
        guard let data = data,
              let categories = try? JSONDecoder().decode([CategoryIM].self, from: data) else {
            return
        }
        
        for budget in categories.flatMap({ $0.budgets }) {
            try? addBudget(id: budget.id, amount: budget.amount, date: budget.date, message: budget.description, category: budget.category)
        }
        
        for category in categories {
            try? addCategory(
                id: category.id,
                name: category.name,
                color: category.color,
                budgets: category.budgets.map({ $0.id }),
                icon: "dollarsign"
            )
        }
    }
    
    struct CategoryIM: Decodable {
        var budgets: [BudgetIM]
        var color: Color
        var id: UUID
        var name: String
    }
    
    struct BudgetIM: Decodable {
        var amount: Double
        var category: UUID
        var date: Date
        var id: UUID
        var description: String?
    }
}
