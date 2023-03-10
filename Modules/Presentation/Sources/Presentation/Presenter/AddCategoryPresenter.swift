//
//  AddCategoryPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI
import Domain
import Data
import UserInterface
import Resource

public enum AddCategoryPresenterString {
    case navigationTitle
    case sectionName
    case rowName
    case placehoderRowName
    case rowColor
    case sectionBudget
    case noBudgetAdd
    case currency
    case removeBudget
    case save
    case addBudget
}

public protocol AddCategoryPresenterProtocol: ObservableObject {
    static var instance: Self { get }
    
    var name: String { get set }
    var color: Color { get set }
    var budgets: [BudgetEntity] { get set }
    
    var alert: BudgetAlert { get set }
    var category: CategoryEntity? { get }
    var buttonForegroundColor: Color { get }
    
    func string(_ string: AddCategoryPresenterString) -> String
    
    func add(budget: BudgetEntity, onError: ((BudgetError) -> Void)?)
    func remove(budget: BudgetEntity, on category: CategoryEntity, onSuccess: (() -> Void)?, onError: ((BudgetError) -> Void)?)
    func save(onSuccess: (() -> Void)?, onError: ((BudgetError) -> Void)?)
}

public final class AddCategoryPresenter: AddCategoryPresenterProtocol {
    public static var instance: Self { Self() }
    
    @Published public var name: String = ""
    @Published public var color: Color = .accentColor
    @Published public var budgets: [BudgetEntity] = []
    @Published public var alert: BudgetAlert = BudgetAlert()

    public private(set) var category: CategoryEntity?
    
    public var buttonForegroundColor: Color {
        canAddNewBudget ? .accentColor : .secondary
    }
    
    public init(category: CategoryEntity? = nil) {
        self.category = category
        if let category = category {
            name = category.name
            budgets = category.budgets
            color = category.color
        }
    }
    
    private func existBudget(_ budget: BudgetEntity) -> Bool {
        budgets.contains(where: {
            $0.date.asString(withDateFormat: .monthYear) == budget.date.asString(withDateFormat: .monthYear)
        })
    }
    
    private func addCategory(
        onSuccess: () -> Void,
        onError: (BudgetError) -> Void
    ) {
        do {
            try Storage.shared.category.addCategory(name: name, color: color, budgets: budgets)
            onSuccess()
        } catch {
            guard let error = error as? BudgetError else { return }
            onError(error)
        }
    }
    
    private func editCategory(
        onSuccess: () -> Void,
        onError: (BudgetError) -> Void
    ) {
        do {
            try Storage.shared.category.editCategory(category!, name: name, color: color, budgets: budgets)
            onSuccess()
        } catch {
            guard let error = error as? BudgetError else { return }
            onError(error)
        }
    }
}

public extension AddCategoryPresenter {
    private var canAddNewBudget: Bool {
        return !budgets.isEmpty && !name.isEmpty
    }
    
    func string(_ string: AddCategoryPresenterString) -> String {
        switch string {
        case .navigationTitle: return Strings.AddCategory.navigationTitle.value
        case .sectionName: return Strings.AddCategory.headerCategory.value
        case .rowName: return Strings.AddCategory.labelName.value
        case .placehoderRowName: return Strings.AddCategory.labelPlaceholderName.value
        case .rowColor: return Strings.AddCategory.labelColor.value
        case .sectionBudget: return Strings.AddCategory.headerBudgets.value
        case .noBudgetAdd: return Strings.AddCategory.noBudgetAdded.value
        case .currency: return Strings.UserInterface.currencyCode.value
        case .removeBudget: return Strings.AddCategory.buttonRemoveBudget.value
        case .save: return Strings.General.save.value
        case .addBudget: return Strings.AddCategory.buttonAddBudget.value
        }
    }
    
    func add(
        budget: BudgetEntity,
        onError: ((BudgetError) -> Void)? = nil
    ) {
        guard !existBudget(budget) else { onError?(.existingBudget); return }
        budgets.append(budget)
    }
    
    func remove(
        budget: BudgetEntity,
        on category: CategoryEntity,
        onSuccess: (() -> Void)? = nil,
        onError: ((BudgetError) -> Void)? = nil
    ) {
        let transactions = Storage.shared.transaction.getAllTransactions().filter { transaction in
            transaction.categoryUUID == category.id &&
            transaction.date.asString(withDateFormat: .monthYear) == budget.date.asString(withDateFormat: .monthYear)
        }
        guard transactions.isEmpty else { onError?(BudgetError.cantDeleteBudget); return }
        guard let index = budgets.firstIndex(where: { $0 == budget }) else { return }
        budgets.remove(at: index)
        onSuccess?()
    }
    
    func save(
        onSuccess: (() -> Void)? = nil,
        onError: ((BudgetError) -> Void)? = nil
    ) {
        if canAddNewBudget, category == nil {
            addCategory(onSuccess: { onSuccess?() }, onError: { onError?($0) })
        } else if canAddNewBudget, category != nil {
            editCategory(onSuccess: { onSuccess?() }, onError: { onError?($0) })
        }
    }
}
