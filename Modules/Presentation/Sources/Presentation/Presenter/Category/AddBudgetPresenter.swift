//
//  AddBudgetPresenter.swift
//  
//
//  Created by Rafael Santos on 25/02/23.
//

import SwiftUI
import Domain
import Data
import Resource

public protocol AddBudgetPresenterProtocol: ObservableObject {
    var router: AddBudgetRouter { get set }
    var viewData: AddBudgetViewData { get set }
    var buttonForegroundColor: Color { get }
    
    func string(_ string: Strings.AddBudget) -> String
    func add(budget: (AddBudgetViewData) -> Void, dismiss: (() -> Void)?)
}

public final class AddBudgetPresenter: AddBudgetPresenterProtocol {
    @Published public var router: AddBudgetRouter
    @Published public var viewData: AddBudgetViewData = .init()
    private let id: UUID?
    
    public init(router: AddBudgetRouter, category: UUID? = nil) {
        self.router = router
        self.id = category
        Task { await start(id: category) }
    }
    
    private var canAddNewBudget: Bool {
        return viewData.amount > 0 && (viewData.category != nil || id != nil)
    }
    
    public var buttonForegroundColor: Color {
        return canAddNewBudget ? .accentColor : .secondary
    }
    
    public func string(_ string: Strings.AddBudget) -> String {
        string.value
    }
    
    public func add(budget: (AddBudgetViewData) -> Void, dismiss: (() -> Void)? = nil) {
        if canAddNewBudget {
            if id != nil { budget(viewData) }
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
                    budgets: budgets + [viewData.id]
                )
                dismiss?()
            }
        }
    }
    
    @MainActor private func start(id: UUID?) async {
        var category: AddBudgetViewData.Category?
        var categories: [AddBudgetViewData.Category]?
        let date: Date = .current
        if let id = id, let categoryFiltered = Worker.shared.category.getCategory(by: id) {
            category = AddBudgetViewData.Category(
                id: categoryFiltered.id,
                color: Color(hex: categoryFiltered.color),
                name: categoryFiltered.name
            )
        } else if id == nil {
            let allCategories = Worker.shared.category.getAllCategories().filter({ category in
                return !category.budgetsValue.contains(where: {
                    $0.date.asString(withDateFormat: .monthYear) == date.asString(withDateFormat: .monthYear)
                })
            })
            categories = allCategories.map({ .init(id: $0.id, color: Color(hex: $0.color), name: $0.name) })
            category = categories?.first
        }
        
        viewData = AddBudgetViewData(
            id: .init(),
            amount: 0,
            date: date,
            message: "",
            category: category,
            categories: categories,
            bind: {}
        )
    }
    
    @MainActor private func reloadViewData() async {
        let allCategories = Worker.shared.category.getAllCategories().filter({ category in
            return !category.budgetsValue.contains(where: {
                $0.date.asString(withDateFormat: .monthYear) == viewData.date.asString(withDateFormat: .monthYear)
            })
        })
        viewData.categories = allCategories.map({ .init(id: $0.id, color: Color(hex: $0.color), name: $0.name) })
        if !(viewData.categories?.contains(where: { $0.id == viewData.category?.id }) ?? false) {
            viewData.category = viewData.categories?.first
        }
    }
}
