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
        categoriesFiltred.map({
            getBudget(by: $0)?.amount ?? 0
        }).reduce(0, +)
    }
    
    public var totalActual: Double {
        categoriesFiltred.map({
            getActualTransaction(by: $0)
        }).reduce(0, +)
    }
    
    public var diff: Double {
        totalBudget - totalActual
    }
    
    public func string(_ string: WidgetString) -> String {
        switch string {
        case .currentValue(let date): return Strings.UserInterface.currentValue.value + " " + date.asString(withDateFormat: .custom("MMMM"))
        case .diff: return String(format: "%02d", 100 - Int((diff * 100) / totalBudget)) + "% Restante"
        }
    }
    
    public var diffColor: Color {
        let diffPercent = 100 - Int((diff * 100) / totalBudget)
        if diffPercent <= 10 { return .red }
        else if diffPercent <= 60 { return .yellow }
        else { return .green }
    }
}
