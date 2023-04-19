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
#if targetEnvironment(macCatalyst)
#else
import ActivityKit
#endif

public enum WidgetString {
    case currentValue(Date)
    case diff
    case value
    case category
    case budget
    case current
}
#if targetEnvironment(macCatalyst)
#else
@available(iOS 16.1, *)
public final class LiveActivityPresenter {
    public static let shared = LiveActivityPresenter()
    public let presenter = WidgetPresenter.shared
    private var activity: Activity<BudgetWidgetAttributes>?
    
    public func activeLiveActivity() {
        let contentState = BudgetWidgetAttributes.ContentState(
            diff: presenter.diff,
            totalBudget: presenter.totalBudget,
            diffColor: presenter.diffColor,
            totalActual: presenter.totalActual,
            chartData: presenter.chartData,
            isEmpty: presenter.isEmpty,
            isActive: presenter.isActive
        )
        
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            do {
                if activity?.activityState != .active {
                    activity = try Activity.request(
                        attributes: BudgetWidgetAttributes(name: ""),
                        contentState: contentState
                    )
                }
            } catch {
                print("\(error.localizedDescription).")
            }
        }
    }
    
    public func updateLiveActivity() {
        let contentState = BudgetWidgetAttributes.ContentState(
            diff: presenter.diff,
            totalBudget: presenter.totalBudget,
            diffColor: presenter.diffColor,
            totalActual: presenter.totalActual,
            chartData: presenter.chartData,
            isEmpty: presenter.isEmpty,
            isActive: presenter.isActive
        )
        if ActivityAuthorizationInfo().areActivitiesEnabled, let activity = activity {
            Task {
                await activity.update(using: contentState)
            }
        }
    }
    
    public func stopLiveActivity() {
        let contentState = BudgetWidgetAttributes.ContentState(
            diff: presenter.diff,
            totalBudget: presenter.totalBudget,
            diffColor: presenter.diffColor,
            totalActual: presenter.totalActual,
            chartData: presenter.chartData,
            isEmpty: presenter.isEmpty,
            isActive: presenter.isActive
        )
        Task {
            await activity?.end(using: contentState, dismissalPolicy: .default)
        }
    }
}
#endif

public final class WidgetPresenter {
    public static let shared = WidgetPresenter()
    private let categoryWorker = CategoryWorker.shared
    private let transactionsWorker = TransactionWorker.shared
    
    private var categoriesFiltred: [CategoryEntity] {
        categoryWorker.getCategories(from: .current)
    }
    
    private func getBudget(by category: CategoryEntity) -> BudgetEntity? {
        category.budgetsValue.first(where: {
            $0.date.asString(withDateFormat: .monthYear) == Date.current.asString(withDateFormat: .monthYear)
        })
    }
    
    private func getActualTransaction(by category: UUID) -> Double {
        transactionsWorker.get(
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
            getActualTransaction(by: $0.id)
        }).reduce(0, +)
    }
    
    public var diff: Double {
        totalBudget - totalActual
    }
    
    public var chartData: [ChartDataItem] {
        [
            .init(label: string(.budget), data: budgetData),
            .init(label: string(.current), data: actualData)
        ]
    }
    
    private var budgetData: [ChartDataItem.DataItem] {
        categoriesFiltred.map({
            .init(category: $0.name.capitalized, value: getBudgetAmountByPeriod(by: $0))
        })
    }
    
    private var actualData: [ChartDataItem.DataItem] {
        categoriesFiltred.map({
            .init(category: $0.name.capitalized, value: getAmountTransactions(by: $0.id))
        })
    }
    
    public var isEmpty: Bool {
        categoriesFiltred.map({
            getAmountTransactions(by: $0.id)
        }).reduce(0, +) <= 0
    }
    
    public var isActive: Bool {
        true
    }
    
    private func getBudgetAmountByPeriod(by category: CategoryEntity) -> Double {
        (category.budgetsValue.first(where: {
            $0.date.asString(withDateFormat: .monthYear) == Date.current.asString(withDateFormat: .monthYear)
        })?.amount ?? 0)
    }
    
    public func getAmountTransactions(by category: UUID) -> Double {
        transactionsWorker.get(
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
        else if diffPercent <= 30 { return .yellow }
        else { return .green }
    }
    
    public var categories: [(color: Color, name: String, percent: Double, percentColor: Color)] {
        var categories: [(color: Color, name: String, percent: (Double, Date), percentColor: Color)] = []
        for category in categoriesFiltred {
            var budget = getBudgetAmountByPeriod(by: category)
            budget = budget == 0 ? 1 : budget
            let transactions = transactionsWorker.get(on: category.id, from: .current, format: .monthYear)
            let actual = transactions.map({ $0.amount }).reduce(0, +)
            let percent = (actual * 100) / budget
            let percentColor = percent >= 90 ? Color.red : percent >= 70 ? Color.yellow : .green
            categories.append((color: Color(hex: category.color), name: category.name, percent: (percent, transactions.first?.date.date ?? .current), percentColor: percentColor))
        }
        categories.sort(by: { $0.percent.1 > $1.percent.1 })
        if categories.count > 6 {
            categories = Array(categories[0...5])
        }
        return categories.map({ (color: $0.color, name: $0.name, percent: $0.percent.0, percentColor: $0.percentColor) })
    }
}
