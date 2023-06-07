//
//  TransactionPresenter.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI
import RefdsUI
import Domain
import Data
import Resource
import RefdsCore

public protocol TransactionPresenterProtocol: ObservableObject {
    var router: TransactionRouter { get }
    var viewData: TransactionViewData { get }
    var date: Date { get set }
    var query: String { get set }
    var isFilterPerDate: Bool { get set }
    var isPresentedAddTransaction: Bool { get set }
    var isPresentedEditTransaction: Bool { get set }
    var showLoading: Bool { get set }
    var alert: AlertItem { get set }
    var transaction: UUID? { get set }
    var selectedPeriod: PeriodItem { get set }
    var isPro: Bool { get set }
    
    func string(_ string: Strings.Transaction) -> String
    func loadData()
    func remove(transaction: UUID, onError: ((BudgetError) -> Void)?)
}

public final class TransactionPresenter: TransactionPresenterProtocol {
    public var router: TransactionRouter
    private var transactionsFiltred: [TransactionEntity] = []
    private var transactions: [TransactionEntity] = []
    private var category: UUID?
    
    @Published public var viewData: TransactionViewData = .init()
    @Published public var date: Date = Date() { didSet { loadData() } }
    @Published public var query: String = "" { didSet { loadSearchResults() } }
    @Published public var isFilterPerDate: Bool = true { didSet { loadData() } }
    @Published public var selectedPeriod: PeriodItem = .month { didSet { loadData() } }
    @Published public var isPresentedAddTransaction: Bool = false
    @Published public var isPresentedEditTransaction: Bool = false
    @Published public var alert: AlertItem = .init()
    @Published public var transaction: UUID?
    @Published public var isPro: Bool = true//false
    @Published public var showLoading: Bool = true
    
    public init(router: TransactionRouter, category: UUID? = nil, date: Date? = nil) {
        self.router = router
        self.category = category
        if let date = date { _date = Published(initialValue: date) }
    }
    
    public func string(_ string: Strings.Transaction) -> String {
        string.value
    }
    
    public func remove(transaction: UUID, onError: ((BudgetError) -> Void)? = nil) {
        do {
            try Worker.shared.transaction.remove(id: transaction)
            loadData()
        } catch {
            guard let error = error as? BudgetError else { return }
            onError?(error)
        }
    }
    
    private func containsTransaction(_ transaction: TransactionEntity) -> Bool {
        guard !query.isEmpty else { return true }
        let query = query.stripingDiacritics.lowercased()
        let description = transaction.description.stripingDiacritics.lowercased().contains(query)
        let category = transaction.categoryValue?.name.stripingDiacritics.lowercased().contains(query) ?? false
        let amount = "\(transaction.amount)".lowercased().contains(query)
        let date = transaction.date.date.asString(withDateFormat: selectedPeriod.dateFormat).lowercased().contains(query)
        return description || category || amount || date
    }
    
    public func loadData() {
        showLoading = true
        Task {
            //await updateNeedModalPro()
            await updateTransactions()
            await updateTransactionsFiltered()
            await updateViewDataValue()
            await updateChartData()
            await updateViewDataTransactions()
            DispatchQueue.main.async { self.showLoading = false }
        }
    }
    
    public func loadSearchResults() {
        showLoading = true
        Task {
            await updateTransactionsFiltered()
            await updateViewDataValue()
            await updateChartData()
            await updateViewDataTransactions()
            //Task { await ProPresenter.shared.updatePurchasedProducts() }
            DispatchQueue.main.async { self.showLoading = false }
        }
    }
    
    @MainActor private func updateNeedModalPro() async {
        //isPro = Worker.shared.settings.get().isPro
    }
    
    private func updateTransactions() async {
        let worker = Worker.shared.transaction
        if let category = category {
            transactions = isFilterPerDate ? (selectedPeriod == .week ? worker.get(
                on: category,
                from: date,
                format: selectedPeriod.dateFormat
            ).filter({ selectedPeriod.containsWeek(originalDate: date, compareDate: $0.date.date) }) : worker.get(
                on: category,
                from: date,
                format: selectedPeriod.dateFormat
            )) : worker.get(on: category)
        } else {
            transactions = isFilterPerDate ? (selectedPeriod == .week ? worker.get(
                from: date,
                format: selectedPeriod.dateFormat
            ).filter({ selectedPeriod.containsWeek(originalDate: date, compareDate: $0.date.date) }) : worker.get(
                from: date,
                format: selectedPeriod.dateFormat
            )) : worker.get()
        }
    }
    
    @MainActor private func updateViewDataTransactions() async {
        let transactions: [TransactionViewData.Transaction] = transactionsFiltred.map({
            .init(
                id: $0.id,
                date: $0.date.date,
                description: $0.message,
                categoryName: $0.categoryValue?.name ?? "",
                categoryColor: Color(hex: $0.categoryValue?.color ?? ""),
                amount: $0.amount,
                categoryIcon: RefdsIconSymbol(rawValue: $0.categoryValue?.icon ?? "dollarsign") ?? .dollarsign
            )
        })
        viewData.transactions = Dictionary(grouping: transactions, by: { $0.date.asString(withDateFormat: .dayMonthYear) })
            .map({ $0.value })
            .sorted(by: { ($0.first?.date ?? Date()) >= ($1.first?.date ?? Date()) })
    }
    
    @MainActor private func updateViewDataValue() async {
        let values = transactionsFiltred.map({ $0.amount })
        viewData.value.value = values.reduce(0, +)
        viewData.value.amount = values.count
    }
    
    @MainActor private func updateChartData() async {
        viewData.chart = transactionsFiltred.map({
            .init(date: $0.date.date, value: $0.amount)
        })
    }
    
    private func updateTransactionsFiltered() async {
        transactionsFiltred = transactions.filter({
            containsTransaction($0)
        })
    }
}
