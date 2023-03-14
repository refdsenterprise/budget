//
//  WidgetPresenter.swift
//  
//
//  Created by Rafael Santos on 13/03/23.
//

import Foundation
import SwiftUI
import Domain
import Data
import Resource

public enum WidgetString {
    case currentValue(Date)
    case diff
    case value
    case category
    case budget
    case current
}

public final class WidgetPresenter {
    public static let shared = WidgetPresenter()
    private let categoryWorker = CategoryStorage.shared
    private let transactionsWorker = TransactionStorage.shared
    
    private var categoriesFiltred: [CategoryEntity] {
        categoryWorker.getCategories(from: .current, format: .monthYear)
    }
    
    private func getBudget(by category: CategoryEntity) -> BudgetEntity? {
        category.budgets.first(where: {
            $0.date.asString(withDateFormat: .monthYear) == Date.current.asString(withDateFormat: .monthYear)
        })
    }
    
    private func getActualTransaction(by category: CategoryEntity) -> Double {
        transactionsWorker.getTransactions(
            on: category,
            from: .current,
            format: .monthYear
        ).map({
            $0.amount
        }).reduce(0, +)
    }
    
    public var totalBudget: Double {
        let totalBudget = categoriesFiltred.map({
            getBudget(by: $0)?.amount ?? 0
        }).reduce(0, +)
        return totalBudget == 0 ? 1 : totalBudget
    }
    
    public var totalActual: Double {
        categoriesFiltred.map({
            getActualTransaction(by: $0)
        }).reduce(0, +)
    }
    
    public var diff: Double {
        totalBudget - totalActual
    }
    
    public var chartData: [(label: String, data: [(category: String, value: Double)])] {
        [
            (label: string(.budget), data: budgetData),
            (label: string(.current), data: actualData)
        ]
    }
    
    private var budgetData: [(category: String, value: Double)] {
        categoriesFiltred.map({
            (category: $0.name.capitalized, value: getBudgetAmountByPeriod(by: $0))
        })
    }
    
    private var actualData: [(category: String, value: Double)] {
        categoriesFiltred.map({
            (category: $0.name.capitalized, value: getAmountTransactions(by: $0))
        })
    }
    
    private func getBudgetAmountByPeriod(by category: CategoryEntity) -> Double {
        (category.budgets.first(where: {
            $0.date.asString(withDateFormat: .monthYear) == Date.current.asString(withDateFormat: .monthYear)
        })?.amount ?? 0)
    }
    
    public func getAmountTransactions(by category: CategoryEntity) -> Double {
        transactionsWorker.getTransactions(
            on: category,
            from: .current,
            format: .monthYear
        ).map({ $0.amount }).reduce(0, +)
    }
    
    public func string(_ string: WidgetString) -> String {
        switch string {
        case .currentValue(let date): return Strings.UserInterface.currentValue.value + " " + date.asString(withDateFormat: .custom("MMMM"))
        case .diff: return String(format: "%02d", 100 - Int((totalActual * 100) / totalBudget)) + "%"
        case .value: return Strings.Budget.value.value
        case .category: return Strings.Budget.category.value
        case .budget: return Strings.Budget.budget.value
        case .current: return Strings.Budget.current.value
        }
    }
    
    public var diffColor: Color {
        let diffPercent = 100 - Int((totalActual * 100) / totalBudget)
        if diffPercent <= 10 { return .red }
        else if diffPercent <= 60 { return .yellow }
        else { return .green }
    }
}
