//
//  BudgetPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 01/01/23.
//

import SwiftUI
import Domain
import Data
import Resource

public protocol BudgetPresenterProtocol: ObservableObject {
    var router: BudgetRouter { get }
    var date: Date { get set }
    var categories: [CategoryEntity] { get set }
    var _transactions: [TransactionEntity] { get set }
    var isFilterPerDate: Bool { get set }
    var selectedPeriod: PeriodEntity { get set }
    var isSelectedVersus: Bool { get set }
    var maxDay: String { get set }
    
    var totalActual: Double { get }
    var totalBudget: Double { get }
    var chartData: [(label: String, data: [(category: String, value: Double)])] { get }
    var transactions: [TransactionEntity] { get }
    var maxTrasaction: TransactionEntity? { get }
    var totalDifference: Double { get }
    
    func string(_ string: Strings.Budget) -> String
    func loadData()
    func getMaxWeekday(completion: (String) -> Void) -> [String]
    func getBudgetAmount(by category: CategoryEntity) -> Double
    func getAmountTransactions(by category: CategoryEntity) -> Double
    func getDifferencePercent(budget: Double, actual: Double, hasPlaces: Bool) -> String
    func getActualColor(actual: Double, budget: Double) -> Color
    func transactions(for weekday: String) -> [TransactionEntity]
    func getPercent(budget: Double, actual: Double, hasPlaces: Bool) -> String
}

public final class BudgetPresenter: BudgetPresenterProtocol {
    public var router: BudgetRouter
    
    @Published public var date: Date = Date()
    @Published public var categories: [CategoryEntity] = []
    @Published public var _transactions: [TransactionEntity] = []
    @Published public var isFilterPerDate: Bool = true { didSet { loadData() } }
    @Published public var selectedPeriod: PeriodEntity = .month
    @Published public var isSelectedVersus: Bool = false
    @Published public var maxDay: String = ""
    
    public init(router: BudgetRouter) {
        self.router = router
    }
    
    public func string(_ string: Strings.Budget) -> String {
        string.value
    }
    
    public func loadData() {
        let category = Storage.shared.category
        let transaction = Storage.shared.transaction
        categories = isFilterPerDate ? category.getCategories(from: date) : category.getAllCategories()
        _transactions = isFilterPerDate ? transaction.getTransactions(from: date) : transaction.getAllTransactions()
    }
    
    public func getMaxWeekday(completion: (String) -> Void) -> [String] {
        var daysCount: [String: Double] = [:]
        _transactions.forEach { transaction in
            let day = transaction.date.asString(withDateFormat: .custom("EEEE")).lowercased()
            daysCount[day] = (daysCount[day] ?? 0) + transaction.amount
        }
        let maxDay = daysCount.max(by: { $0.value < $1.value })?.key ?? ""
        completion(maxDay)
        return daysCount.sorted(by: { $0.value > $1.value }).map({ $0.key })
    }
    
    public func getBudgetAmount(by category: CategoryEntity) -> Double {
        isFilterPerDate ? getBudgetAmountByPeriod(by: category) : getBudgetAmountAll(by: category)
    }
    
    public func getAmountTransactions(by category: CategoryEntity) -> Double {
        getTransactions(by: category).map({ $0.amount }).reduce(0, +)
    }
    
    public func getDifferencePercent(budget: Double, actual: Double, hasPlaces: Bool = false) -> String {
        var percent = (actual * 100) / budget
        percent = 100 - percent
        if !hasPlaces {
            return String(format: "%02.0f", percent, actual, budget) + "%"
        } else {
            return String(format: "%02.02f", percent).replacingOccurrences(of: ".", with: ",") + "%"
        }
    }
    
    public func getActualColor(actual: Double, budget: Double) -> Color {
        let budget = budget == 0 ? 1 : budget
        let percent = (actual * 100) / budget
        let breaking = percent >= 90
        let warning = percent >= 70
        return breaking ? .red : warning ? .yellow : .accentColor
    }
    
    public func transactions(for weekday: String) -> [TransactionEntity] {
        _transactions.filter { transaction in
            let day = transaction.date.asString(withDateFormat: .custom("EEEE")).lowercased()
            return weekday.lowercased() == day
        }
    }
    
    public func getPercent(budget: Double, actual: Double, hasPlaces: Bool = false) -> String {
        let percent = (actual * 100) / budget
        if !hasPlaces {
            return String(format: "%02.0f", percent, actual, budget) + "%"
        } else {
            return String(format: "%02.02f", percent).replacingOccurrences(of: ".", with: ",") + "%"
        }
    }
    
    public func getTransactions(by category: CategoryEntity) -> [TransactionEntity] {
        isFilterPerDate ? getTransactionsByPeriod(by: category) : getTransactionsAll(by: category)
    }
    
    private func getBudgetAmountAll(by category: CategoryEntity) -> Double {
        category.budgets.map({ $0.amount }).reduce(0, +)
    }
    
    private func getBudgetAmountByPeriod(by category: CategoryEntity) -> Double {
        (category.budgets.first(where: {
            $0.date.asString(withDateFormat: PeriodEntity.month.dateFormat) == date.asString(withDateFormat: PeriodEntity.month.dateFormat)
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
    
    private func getTransactionsAll(by category: CategoryEntity) -> [TransactionEntity] {
        _transactions.filter({ $0.category == category })
    }
    
    private func getTransactionsByPeriod(by category: CategoryEntity) -> [TransactionEntity] {
        _transactions.filter({
            $0.category == category &&
            (selectedPeriod == .week ? selectedPeriod.containsWeek(originalDate: date, compareDate: $0.date) : $0.date.asString(withDateFormat: selectedPeriod.dateFormat) == date.asString(withDateFormat: selectedPeriod.dateFormat))
        })
    }

    public func getBudgetData() -> [(category: String, value: Double)] {
        categories.map({
            (category: $0.name.capitalized, value: getBudgetAmount(by: $0))
        })
    }
    
    public func getActualData() -> [(category: String, value: Double)] {
        categories.map({
            (category: $0.name.capitalized, value: getAmountTransactions(by: $0))
        })
    }
    
    public func getMaxBudget() -> Double? {
        categories.map({ getBudgetAmount(by: $0) }).max()
    }
    
    public func getMaxActual() -> Double? {
        categories.map({ getAmountTransactions(by: $0) }).max()
    }
    
    public func getDifferencePercent(budget: Double, actual: Double) -> Double {
        let percent = (actual * 100) / budget
        return (100 - percent) / 100
    }
    
    public func getChartDataTransactions() -> [(date: Date, value: Double)]{
        isFilterPerDate ? Storage.shared.transaction.getChartDataTransactions(from: date, period: selectedPeriod) : Storage.shared.transaction.getChartDataTransactions()
    }  
}

// MARK: - Attributes
extension BudgetPresenter {
    public var totalActual: Double {
        categories.map({
            return getAmountTransactions(by: $0)
        }).reduce(0, +)
    }
    
    public var totalBudget: Double {
        isFilterPerDate ? getTotalBudgetByPeriod() : getTotalBudgetAll()
    }
    
    public var chartData: [(label: String, data: [(category: String, value: Double)])] {
        [
            (label: string(.budget), data: getBudgetData()),
            (label: string(.current), data: getActualData())
        ]
    }
    
    public var transactions: [TransactionEntity] {
        isFilterPerDate ? _transactions.filter({
            (selectedPeriod == .week ? selectedPeriod.containsWeek(originalDate: date, compareDate: $0.date) : $0.date.asString(withDateFormat: selectedPeriod.dateFormat) == date.asString(withDateFormat: selectedPeriod.dateFormat))
        }) : _transactions
    }
    
    public var maxTrasaction: TransactionEntity? {
        transactions.max(by: { $0.amount < $1.amount })
    }
    
    public var totalDifference: Double {
        categories.map({
            let budget = getBudgetAmount(by: $0)
            let actual = getAmountTransactions(by: $0)
            return budget - actual
        }).reduce(0, +)
    }
}
