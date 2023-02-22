//
//  BudgetPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 01/01/23.
//

import SwiftUI

final class BudgetPresenter: ObservableObject {
    static var instance: Self { Self() }
    
    @Published var date: Date = Date()
    @Published var categories: [CategoryEntity] = []
    @Published var transactions: [TransactionEntity] = []
    @Published var isFilterPerDate = true
    @Published var selectedPeriod: BudgetPresenter.Period = .month
    @Published var isSelectedVersus = false
    
    func loadData() {
        let category = Storage.shared.category
        let transaction = Storage.shared.transaction
        categories = isFilterPerDate ? category.getCategories(from: date) : category.getAllCategories()
        transactions = isFilterPerDate ? transaction.getTransactions(from: date) : transaction.getAllTransactions()
    }
    
    func getTotalActual() -> Double {
        categories.map({
            return getAmountTransactions(by: $0)
        }).reduce(0, +)
    }
    
    func getTotalDifference() -> Double {
        categories.map({
            let budget = getBudgetAmount(by: $0)
            let actual = getAmountTransactions(by: $0)
            return budget - actual
        }).reduce(0, +)
    }
    
    func getBudgetAmount(by category: CategoryEntity) -> Double {
        isFilterPerDate ? getBudgetAmountByPeriod(by: category) : getBudgetAmountAll(by: category)
    }
    
    func getTotalBudget() -> Double {
        isFilterPerDate ? getTotalBudgetByPeriod() : getTotalBudgetAll()
    }
    
    func getTransactions(by category: CategoryEntity) -> [TransactionEntity] {
        isFilterPerDate ? getTransactionsByPeriod(by: category) : getTransactionsAll(by: category)
    }
    
    private func getBudgetAmountAll(by category: CategoryEntity) -> Double {
        category.budgets.map({ $0.amount }).reduce(0, +)
    }
    
    private func getBudgetAmountByPeriod(by category: CategoryEntity) -> Double {
        (category.budgets.first(where: {
            $0.date.asString(withDateFormat: BudgetPresenter.Period.month.dateFormat) == date.asString(withDateFormat: BudgetPresenter.Period.month.dateFormat)
        })?.amount ?? 0) / selectedPeriod.averageFactor
    }
    
    private func getTotalBudgetAll() -> Double {
        let allBudgetPerPeriod = categories.flatMap({ $0.budgets }).filter({
            let currentDate = $0.date.asString(withDateFormat: selectedPeriod.dateFormat)
            let date = date.asString(withDateFormat: selectedPeriod.dateFormat)
            return currentDate == date
        }).map({ $0.amount }).reduce(0, +)
        let allBudget = categories.flatMap({ $0.budgets }).map({ $0.amount }).reduce(0, +)
        return isFilterPerDate ? allBudgetPerPeriod : allBudget
    }
    
    private func getTotalBudgetByPeriod() -> Double {
        getTotalBudgetAll() / selectedPeriod.averageFactor
    }
    
    func getAmountTransactions(by category: CategoryEntity) -> Double {
        getTransactions(by: category).map({ $0.amount }).reduce(0, +)
    }
    
    private func getTransactionsAll(by category: CategoryEntity) -> [TransactionEntity] {
        transactions.filter({ $0.category == category })
    }
    
    private func getTransactionsByPeriod(by category: CategoryEntity) -> [TransactionEntity] {
        transactions.filter({
            $0.category == category &&
            (selectedPeriod == .week ? selectedPeriod.containsWeek(originalDate: date, compareDate: $0.date) : $0.date.asString(withDateFormat: selectedPeriod.dateFormat) == date.asString(withDateFormat: selectedPeriod.dateFormat))
        })
    }
    
    func getActualColor(actual: Double, budget: Double) -> Color {
        let accent = budget - actual > 0
        let secondary = budget - actual == 0
        return accent ? .accentColor : secondary ? .yellow : .pink
    }
    
    func getChartData() -> [(label: String, data: [(category: String, value: Double)])] {
        return [
            (label: "Budget", data: getBudgetData()),
            (label: "Atual", data: getActualData())
        ]
    }
    
    func getBudgetData() -> [(category: String, value: Double)] {
        categories.map({
            (category: $0.name.capitalized, value: getBudgetAmount(by: $0))
        })
    }
    
    func getActualData() -> [(category: String, value: Double)] {
        categories.map({
            (category: $0.name.capitalized, value: getAmountTransactions(by: $0))
        })
    }
    
    func getMaxBudget() -> Double? {
        categories.map({ getBudgetAmount(by: $0) }).max()
    }
    
    func getMaxActual() -> Double? {
        categories.map({ getAmountTransactions(by: $0) }).max()
    }
    
    func getPercent(budget: Double, actual: Double, hasPlaces: Bool = false) -> String {
        let percent = (actual * 100) / budget
        if !hasPlaces {
            return String(format: "%02.0f", percent, actual, budget) + "%"
        } else {
            return String(format: "%02.02f", percent).replacingOccurrences(of: ".", with: ",") + "%"
        }
    }
    
    func getDifferencePercent(budget: Double, actual: Double, hasPlaces: Bool = false) -> String {
        var percent = (actual * 100) / budget
        percent = 100 - percent
        if !hasPlaces {
            return String(format: "%02.0f", percent, actual, budget) + "%"
        } else {
            return String(format: "%02.02f", percent).replacingOccurrences(of: ".", with: ",") + "%"
        }
    }
    
    func getDifferencePercent(budget: Double, actual: Double) -> Double {
        let percent = (actual * 100) / budget
        return (100 - percent) / 100
    }
    
    func getTransactions() -> [TransactionEntity] {
        isFilterPerDate ? transactions.filter({
            (selectedPeriod == .week ? selectedPeriod.containsWeek(originalDate: date, compareDate: $0.date) : $0.date.asString(withDateFormat: selectedPeriod.dateFormat) == date.asString(withDateFormat: selectedPeriod.dateFormat))
        }) : transactions
    }
    
    func getChartDataTransactions() -> [(date: Date, value: Double)]{
        isFilterPerDate ? Storage.shared.transaction.getChartDataTransactions(from: date, period: selectedPeriod) : Storage.shared.transaction.getChartDataTransactions()
    }
    
    func getMaxTrasaction() -> TransactionEntity? {
        return getTransactions().max(by: { $0.amount < $1.amount })
    }
    
    func getMaxWeekday(completion: (String) -> Void) -> [String] {
        var daysCount: [String: Double] = [:]
        transactions.forEach { transaction in
            let day = transaction.date.asString(withDateFormat: "EEEE").lowercased()
            daysCount[day] = (daysCount[day] ?? 0) + transaction.amount
        }
        let maxDay = daysCount.max(by: { $0.value < $1.value })?.key ?? ""
        completion(maxDay)
        return daysCount.sorted(by: { $0.value > $1.value }).map({ $0.key })
    }
    
    func getTransactionsWeekday(weekday: String) -> [TransactionEntity] {
        transactions.filter { transaction in
            let day = transaction.date.asString(withDateFormat: "EEEE").lowercased()
            return weekday.lowercased() == day
        }
    }
}

extension BudgetPresenter {
    enum Period: Int {
        case month = 0
        case daily = 1
        case week = 2
        
        var label: String {
            switch self {
            case .month: return "mensal"
            case .daily: return "diário"
            case .week: return "semanal"
            }
        }
        
        var dateFormat: String {
            switch self {
            case .month: return "MM/yyyy"
            case .daily: return "dd/MM/yyyy"
            case .week: return "EEEE/MM/yyyy"
            }
        }
        
        func containsWeek(originalDate: Date, compareDate: Date) -> Bool {
            let calendar = Calendar.current
            let dayOfWeek = calendar.component(.weekday, from: originalDate)
            let day = calendar.component(.day, from: originalDate)
            let days = Array(1...7).map { weekday in
                if weekday == dayOfWeek { return day }
                else if weekday < dayOfWeek { return day - (dayOfWeek - weekday) }
                else { return day + (weekday - dayOfWeek) }
            }
            let compareDay = calendar.component(.day, from: compareDate)
            return days.contains(compareDay)
        }
        
        var averageFactor: Double {
            switch self {
            case .month: return 1
            case .daily: return 30
            case .week: return 4
            }
        }
    }
}
