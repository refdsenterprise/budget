//
//  AddCategoryPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI
import RefdsUI
import Domain
import Data
import Resource

public protocol AddCategoryPresenterProtocol: ObservableObject {
    var router: AddCategoryRouter { get set }
    var viewData: AddCategoryViewData { get set }
    var alert: AlertItem { get set }
    var isPresentedEditBudget: Bool { get set }
    var buttonForegroundColor: Color { get }
    var colorOptions: [RefdsColor] { get }
    var id: UUID? { get }
    var budget: UUID? { get set }
    var canAddNewCategory: Bool { get }
    
    func string(_ string: Strings.AddCategory) -> String
    func add(budget: AddBudgetViewData) async
    func remove(budget: AddBudgetViewData, on category: AddCategoryViewData) async
    func save(onSuccess: (() -> Void)?)
    func start(id: UUID?) async
}

public final class AddCategoryPresenter: AddCategoryPresenterProtocol {
    public var router: AddCategoryRouter
    @Published public var isPresentedEditBudget: Bool = false
    @Published public var viewData: AddCategoryViewData = .init()
    @Published public var alert: AlertItem = .init()
    public var colorOptions: [RefdsColor] { return RefdsColor.Default.allCases.map({ $0.rawValue }) }
    public var id: UUID?
    public var budget: UUID?
    var isStarted: Bool = false
    
    public var buttonForegroundColor: Color {
        canAddNewCategory ? .accentColor : .secondary
    }
    
    public var canAddNewCategory: Bool {
        return !viewData.budgets.isEmpty && !viewData.name.isEmpty
    }
    
    public init(router: AddCategoryRouter, category: UUID? = nil) {
        self.router = router
        self.id = category
    }
    
    @MainActor public func start(id: UUID?) async {
        if let id = id, let category = Worker.shared.category.getCategory(by: id), !isStarted {
            viewData = .init(
                id: category.id,
                name: category.name.capitalized,
                color: Color(hex: category.color),
                icon: RefdsIconSymbol(rawValue: category.icon) ?? .dollarsign,
                budgets: category.budgetsValue.map({
                    AddBudgetViewData(
                        id: $0.id,
                        amount: $0.amount,
                        date: $0.date.date,
                        message: $0.message ?? "",
                        category: .init(
                            id: id,
                            color: Color(hex: category.color),
                            name: category.name,
                            icon: RefdsIconSymbol(rawValue: category.icon) ?? .dollarsign
                        ),
                        categories: nil,
                        bind: {}
                    )
                })
            )
        }
        isStarted = true
    }
    
    public func string(_ string: Strings.AddCategory) -> String {
        string.value
    }
    
    @MainActor public func add(budget: AddBudgetViewData) async {
        if let id = self.budget, let index = viewData.budgets.firstIndex(where: { $0.id == id }) {
            viewData.budgets[index] = budget
        } else {
            guard !existBudget(budget) else {
                alert = .init(error: .existingBudget)
                return
            }
            viewData.budgets.append(budget)
        }
    }
    
    @MainActor public func remove(budget: AddBudgetViewData, on category: AddCategoryViewData) async {
        let transactions = Worker.shared.transaction.get().filter {
            let category = $0.category == category.id
            let date = $0.date.asString(withDateFormat: .monthYear) == budget.date.asString(withDateFormat: .monthYear)
            return category && date
        }
        
        guard transactions.isEmpty else {
            alert = .init(error: .cantDeleteBudget)
            return
        }
        
        guard let index = viewData.budgets.firstIndex(where: { $0.id == budget.id }) else {
            alert = .init(error: .notFoundBudget)
            return
        }
        
        viewData.budgets.remove(at: index)
    }
    
    private func existBudget(_ budget: AddBudgetViewData) -> Bool {
        viewData.budgets.contains(where: {
            let date = $0.date.asString(withDateFormat: .monthYear) == budget.date.asString(withDateFormat: .monthYear)
            let category = $0.category?.id == budget.category?.id
            return date && category
        })
    }
    
    public func save(onSuccess: (() -> Void)? = nil) {
//        guard Worker.shared.category.getAllBudgets().count < 5 || Worker.shared.settings.get().isPro else {
//            alert = .init(error: .cantAddCategoryPro)
//            return
//        }
        
        if canAddNewCategory {
            do {
                for budget in viewData.budgets {
                    try Worker.shared.category.addBudget(
                        id: budget.id,
                        amount: budget.amount,
                        date: budget.date,
                        message: budget.message,
                        category: viewData.id
                    )
                }
                try Worker.shared.category.addCategory(
                    id: viewData.id,
                    name: viewData.name,
                    color: viewData.color,
                    budgets: viewData.budgets.map({ $0.id }),
                    icon: viewData.icon.rawValue
                )
                onSuccess?()
            } catch {
                guard let error = error as? BudgetError else { return }
                alert = .init(error: error)
            }
        }
    }
}
