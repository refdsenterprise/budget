//
//  BudgetPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 01/01/23.
//

import SwiftUI
import RefdsUI
import Domain
import Data
import Resource

public protocol BudgetPresenterProtocol: ObservableObject {
    var router: BudgetRouter { get }
    var viewData: BudgetViewData { get set }
    var maxDay: String { get set }
    var date: Date { get set }
    var isFilterPerDate: Bool { get set }
    var selectedPeriod: PeriodItem { get set }
    var needShowModalPro: Bool { get set }
    var showLoading: Bool { get set }
    var bubbleName: String { get set }
    var bubbleColor: Color { get set }
    
    func string(_ string: Strings.Budget) -> String
    func loadData()
    func loadWeekDayDetail()
    func addBubble() async
    func removeBubble(id: UUID) async
}

public final class BudgetPresenter: BudgetPresenterProtocol {
    public var router: BudgetRouter
    @Published public var viewData: BudgetViewData = .init()
    
    @Published public var date: Date = Date() { didSet { loadData() } }
    @Published public var maxDay: String = "" { didSet { loadWeekDayDetail() } }
    @Published public var isFilterPerDate: Bool = true { didSet { loadData() } }
    @Published public var selectedPeriod: PeriodItem = .month { didSet { loadData() } }
    @Published public var needShowModalPro: Bool = false
    @Published public var showLoading: Bool = true
    @Published public var bubbleName: String = ""
    @Published public var bubbleColor: Color = .accentColor
    
    private var categories: [CategoryEntity] = []
    private var transactions: [TransactionEntity] = []
    
    public init(router: BudgetRouter) {
        self.router = router
    }
    
    public func string(_ string: Strings.Budget) -> String {
        string.value
    }
    
    public func loadData() {
        viewData = .init()
        showLoading = true
        Task {
            await updateShowModalPro()
            await updateBudgets()
            await updateTransactions()
            await updateViewDataValue()
            if !needShowModalPro {
                Task {
                    await updateViewDataRemaingValue()
                }
                Task { await updateViewDataRemainingCategories() }
                Task { await updateViewDataChart() }
                Task { await updateViewDataBiggerBuy() }
                Task {
                    await updateViewDataWeekDays()
                    await updateViewDataWeekDaysDetail()
                }
                Task { await updateViewDataBubble() }
                Task { await ProPresenter.shared.updatePurchasedProducts() }
            }
            DispatchQueue.main.async { self.showLoading = false }
        }
    }
    
    public func loadWeekDayDetail() {
        Task { await updateViewDataWeekDaysDetail() }
    }
    
    @MainActor private func updateShowModalPro() async {
        //needShowModalPro = !Worker.shared.settings.get().isPro
    }
    
    @MainActor private func updateBudgets() async {
        let categoryWorker = Worker.shared.category
        let transactionWorker = Worker.shared.transaction
        categories = isFilterPerDate ? categoryWorker.getCategories(from: date) : categoryWorker.getAllCategories()
        transactions = isFilterPerDate ? transactionWorker.get(from: date) : transactionWorker.get()
    }
    
    @MainActor private func updateTransactions() async {
        transactions = isFilterPerDate ? transactions.filter({
            (selectedPeriod == .week ? selectedPeriod.containsWeek(originalDate: date, compareDate: $0.date.date) : $0.date.date.asString(withDateFormat: selectedPeriod.dateFormat) == date.asString(withDateFormat: selectedPeriod.dateFormat))
        }) : transactions
    }
    
    @MainActor private func updateViewDataValue() async {
        viewData.value.totalBudget = getTotalBudgetByPeriod()
        viewData.value.totalActual = getTotalActualByPeriod()
    }
    
    @MainActor private func updateViewDataRemainingCategories() async {
        viewData.remainingCategory = categories.map({
            let transaction = self.getAmountTransactions(by: $0.id)
            let budget = self.getBudgetAmount(by: $0)
            let percent = self.getPercent(budget: budget, actual: transaction)
            let percentString = self.getDifferencePercentString(budget: budget, actual: transaction)
            return .init(
                id: $0.id,
                name: $0.name,
                value: budget - transaction,
                percent: percent,
                percentString: percentString,
                percentColor: percent >= 100 ? .red : percent >= 70 ? .yellow : .green
            )
        })
    }
    
    @MainActor private func updateViewDataRemaingValue() async {
        let budget = viewData.value.totalBudget
        let actual = viewData.value.totalActual
        let percentString = getDifferencePercentString(budget: budget, actual: actual)
        viewData.remainingCategoryValue = .init(
            amount: budget - actual,
            percentString: percentString
        )
    }
    
    @MainActor private func updateViewDataChart() async {
        viewData.amountTransactions = transactions.count
        viewData.chart = [
            .init(label: string(.budget), data: getBudgetData()),
            .init(label: string(.current), data: getActualData())
        ]
    }
    
    @MainActor private func updateViewDataBiggerBuy() async {
        guard let biggerTransaction = transactions.max(by: {
            $0.amount < $1.amount
        }), let category = biggerTransaction.categoryValue else { return }
        viewData.biggerBuy = .init(
            id: biggerTransaction.id,
            date: biggerTransaction.date.date,
            description: biggerTransaction.message,
            categoryName: category.name,
            categoryColor: Color(hex: category.color),
            amount: biggerTransaction.amount
        )
    }
    
    @MainActor private func updateViewDataWeekDays() async {
        var daysCount: [String: Double] = [:]
        transactions.forEach { transaction in
            let day = transaction.date.asString(withDateFormat: .custom("EEEE")).lowercased()
            daysCount[day] = (daysCount[day] ?? 0) + transaction.amount
        }
        let maxDay = daysCount.max(by: { $0.value < $1.value })?.key ?? ""
        viewData.weekdays = daysCount.sorted(by: { $0.value > $1.value }).map({ $0.key })
        DispatchQueue.main.async { if self.maxDay.isEmpty { self.maxDay = maxDay } }
    }
    
    @MainActor private func updateViewDataWeekDaysDetail() async {
        let transactions = transactions.filter { transaction in
            let day = transaction.date.asString(withDateFormat: .custom("EEEE"))
            return self.maxDay.lowercased() == day.lowercased()
        }.map({
            TransactionViewData.Transaction(
                id: $0.id,
                date: $0.date.date,
                description: $0.message,
                categoryName: $0.categoryValue?.name ?? "",
                categoryColor: Color(hex: $0.categoryValue?.color ?? ""),
                amount: $0.amount
            )
        })
        let amount = transactions.map({ $0.amount }).reduce(0, +)
        let amountTransactions = transactions.count
        let totalActual = getTotalActual()
        let percentString = getPercentString(budget: totalActual, actual: amount)
        viewData.weekdaysDetail = .init(
            amount: amount,
            percentString: percentString,
            amountTransactions: amountTransactions
        )
        viewData.weekdayTransactions = transactions
    }
    
    @MainActor private func updateViewDataBubble() async {
        let bubbles = Worker.shared.bubble.get()
        var dataItem = bubbles.map { bubble in
            let value = transactions.filter({ $0.description.lowercased().stripingDiacritics.contains(bubble.name.lowercased()) }).map({ $0.amount }).reduce(0, +)
            return BudgetViewData.Bubble(id: bubble.id, title: bubble.name.capitalized, value: CGFloat(value), color: Color(hex: bubble.color), realValue: value)
        }.sorted(by: { $0.value > $1.value })
        if let maxBubbleItem = dataItem.max(by: { $0.value < $1.value }) {
            dataItem = dataItem.map({ item in
                let scale = item.value * 300 / (maxBubbleItem.value == 0 ? 1 : maxBubbleItem.value)
                return .init(id: item.id, title: item.title, value: scale, color: item.color, realValue: item.realValue)
            })
        }
        
        viewData.bubbleWords = dataItem
    }
    
    @MainActor public func addBubble() async {
        guard !bubbleName.isEmpty else { return }
        try? Worker.shared.bubble.add(id: .init(), name: bubbleName, color: bubbleColor)
        await updateViewDataBubble()
        bubbleName = ""
        bubbleColor = .accentColor
    }
    
    public func removeBubble(id: UUID) async {
        try? Worker.shared.bubble.remove(id: id)
        await updateViewDataBubble()
    }
    
    private func getTotalBudget() -> Double {
        let allBudgetPerPeriod = categories.flatMap({ $0.budgetsValue }).filter({
            let currentDate = $0.date.date.asString(withDateFormat: selectedPeriod.dateFormat)
            let date = date.asString(withDateFormat: selectedPeriod.dateFormat)
            return currentDate == date
        }).map({ $0.amount }).reduce(0, +)
        let allBudget = categories.flatMap({ $0.budgetsValue }).map({ $0.amount }).reduce(0, +)
        return isFilterPerDate ? allBudgetPerPeriod : allBudget
    }
    
    private func getTotalActual() -> Double {
        transactions.map({ $0.amount }).reduce(0, +)
    }
    
    private func getAmountTransactions(by category: UUID) -> Double {
        getTransactions(by: category).map({ $0.amount }).reduce(0, +)
    }
    
    private func getBudgetAmount(by category: CategoryEntity) -> Double {
        isFilterPerDate ? getBudgetAmountByPeriod(by: category) : getBudgetAmountAll(by: category)
    }
    
    private func getTransactions(by category: UUID) -> [TransactionEntity] {
        isFilterPerDate ? getTransactionsByPeriod(by: category) : getTransactionsAll(by: category)
    }
    
    private func getBudgetAmountAll(by category: CategoryEntity) -> Double {
        category.budgetsValue.map({ $0.amount }).reduce(0, +)
    }
    
    private func getBudgetAmountByPeriod(by category: CategoryEntity) -> Double {
        (category.budgetsValue.first(where: {
            $0.date.asString(withDateFormat: PeriodItem.month.dateFormat) == date.asString(withDateFormat: PeriodItem.month.dateFormat)
        })?.amount ?? 0) / selectedPeriod.averageFactor
    }
    
    private func getTotalActualByPeriod() -> Double {
        getTotalActual() / selectedPeriod.averageFactor
    }
    
    private func getTotalBudgetByPeriod() -> Double {
        getTotalBudget() / selectedPeriod.averageFactor
    }
    
    private func getTransactionsAll(by category: UUID) -> [TransactionEntity] {
        transactions.filter({ $0.category == category })
    }
    
    private func getTransactionsByPeriod(by category: UUID) -> [TransactionEntity] {
        transactions.filter({
            $0.category == category &&
            (selectedPeriod == .week ? selectedPeriod.containsWeek(originalDate: date, compareDate: $0.date.date) : $0.date.asString(withDateFormat: selectedPeriod.dateFormat) == date.asString(withDateFormat: selectedPeriod.dateFormat))
        })
    }

    private func getBudgetData() -> [BudgetViewData.BudgetChart.ChartData] {
        categories.map {
            .init(
                category: $0.name.uppercased(),
                value: getBudgetAmount(by: $0)
            )
        }
    }
    
    private func getActualData() -> [BudgetViewData.BudgetChart.ChartData] {
        categories.map {
            .init(
                category: $0.name.uppercased(),
                value: getAmountTransactions(by: $0.id)
            )
        }
    }
    
    public func getPercentString(budget: Double, actual: Double) -> String {
        let budget = budget == 0 ? 1 : budget
        let percent = (actual * 100) / budget
        return String(format: "%02.02f", percent).replacingOccurrences(of: ".", with: ",") + "%"
    }
    
    private func getDifferencePercentString(budget: Double, actual: Double) -> String {
        let budget = budget == 0 ? 1 : budget
        var percent = (actual * 100) / budget
        percent = 100 - percent
        return String(format: "%02.02f", percent).replacingOccurrences(of: ".", with: ",") + "%"
    }
    
    private func getPercent(budget: Double, actual: Double) -> Double {
        let budget = budget == 0 ? 1 : budget
        let percent = (actual * 100) / budget
        return percent > 100 ? 100 : percent
    }
}
