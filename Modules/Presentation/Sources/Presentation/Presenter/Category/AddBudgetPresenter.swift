//
//  AddBudgetPresenter.swift
//  
//
//  Created by Rafael Santos on 25/02/23.
//

import SwiftUI
import RefdsUI
import Domain
import Data
import Resource

public protocol AddBudgetPresenterProtocol: ObservableObject {
    var router: AddBudgetRouter { get set }
    var viewData: AddBudgetViewData { get set }
    var buttonForegroundColor: Color { get }
    var category: UUID? { get }
    var budget: UUID? { get }
    var isStarted: Bool { get }
    
    func string(_ string: Strings.AddBudget) -> String
    func add(budget: (AddBudgetViewData) -> Void, dismiss: (() -> Void)?)
    func start(categoryID: UUID?, budgetID: UUID?) async
}

public final class AddBudgetPresenter: AddBudgetPresenterProtocol {
    @Published public var router: AddBudgetRouter
    @Published public var viewData: AddBudgetViewData = .init()
    public var category: UUID?
    public var budget: UUID?
    public var isStarted: Bool = false
    
    public init(router: AddBudgetRouter, category: UUID? = nil, budget: UUID? = nil) {
        self.router = router
        self.category = category
        self.budget = budget
    }
    
    private var canAddNewBudget: Bool {
        return viewData.amount > 0 && (viewData.category != nil || category != nil)
    }
    
    public var buttonForegroundColor: Color {
        return canAddNewBudget ? .accentColor : .secondary
    }
    
    public func string(_ string: Strings.AddBudget) -> String {
        string.value
    }
    
    public func add(budget: (AddBudgetViewData) -> Void, dismiss: (() -> Void)? = nil) {
        if canAddNewBudget {
            if category != nil { budget(viewData) }
            else if let category = viewData.category {
                try? Worker.shared.category.addBudget(
                    id: viewData.id,
                    amount: viewData.amount,
                    date: viewData.date,
                    message: viewData.message,
                    category: category.id
                )
                let budgets = Worker.shared.category.getCategory(by: category.id)?.budgets ?? []
                try? Worker.shared.category.addCategory(
                    id: category.id,
                    name: category.name,
                    color: category.color,
                    budgets: budgets + [viewData.id],
                    icon: category.icon.rawValue
                )
                dismiss?()
            }
        }
    }
    
    @MainActor public func start(categoryID: UUID?, budgetID: UUID?) async {
        var category: AddBudgetViewData.Category?
        var categories: [AddBudgetViewData.Category]?
        var amount: Double = 0
        var message: String = ""
        let date: Date = .current
        if let id = categoryID, let categoryFiltered = Worker.shared.category.getCategory(by: id) {
            category = AddBudgetViewData.Category(
                id: categoryFiltered.id,
                color: Color(hex: categoryFiltered.color),
                name: categoryFiltered.name,
                icon: RefdsIconSymbol(rawValue: categoryFiltered.icon) ?? .dollarsign
            )
            if let id = budgetID, let budget = Worker.shared.category.getBudget(in: id) {
                amount = budget.amount
                message = budget.message ?? ""
            }
        } else if categoryID == nil {
            let allCategories = Worker.shared.category.getAllCategories().filter({ category in
                return !category.budgetsValue.contains(where: {
                    $0.date.asString(withDateFormat: .monthYear) == date.asString(withDateFormat: .monthYear)
                })
            })
            categories = allCategories.map({ .init(id: $0.id, color: Color(hex: $0.color), name: $0.name, icon: RefdsIconSymbol(rawValue: $0.icon) ?? .dollarsign) })
            category = categories?.first
        }
        
        viewData = AddBudgetViewData(
            id: budgetID ?? .init(),
            amount: amount,
            date: date,
            message: message,
            category: category,
            categories: categories,
            bind: {
                if categoryID == nil {
                    Task { await self.reloadViewData() }
                }
            }
        )
        isStarted = true
    }
    
    @MainActor private func reloadViewData() async {
        let allCategories = Worker.shared.category.getAllCategories().filter({ category in
            return !category.budgetsValue.contains(where: {
                $0.date.asString(withDateFormat: .monthYear) == viewData.date.asString(withDateFormat: .monthYear)
            })
        })
        viewData.categories = allCategories.map({ .init(id: $0.id, color: Color(hex: $0.color), name: $0.name, icon: RefdsIconSymbol(rawValue: $0.icon) ?? .dollarsign) })
        if !(viewData.categories?.contains(where: { $0.id == viewData.category?.id }) ?? false) {
            viewData.category = viewData.categories?.first
        }
    }
}
