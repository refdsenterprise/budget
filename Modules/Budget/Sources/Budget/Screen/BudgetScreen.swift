//
//  BudgetScreen.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI
import Charts
import Domain
import Presentation
import UserInterface

public struct BudgetScreen<Presenter: BudgetPresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    @State private var selection: Int = 0
    @State private var showDatePicker = false
    @Environment(\.colorScheme) var colorScheme
    
    public init(presenter: Presenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        content
            .navigationTitle(presenter.string(.navigationTitle(presenter.isFilterPerDate ? presenter.date.asString(withDateFormat: .custom("MMMM")).capitalized : "")))
            .onAppear { presenter.loadData() }
    }
    
    private var content: some View {
        List {
            let actual = presenter.totalActual
            let budget = presenter.totalBudget
            
            sectionValue(budget: budget, actual: actual)
            sectionOptions
            
            if !presenter.categories.isEmpty {
                sectionDifference
                sectionValueDifference(budget: budget, actual: actual)
                
                if let chartData = presenter.chartData,
                   !chartData.flatMap({ $0.data }).isEmpty,
                   let transctions = presenter.transactions {
                    sectionTransactions(chartData: chartData, transactions: transctions)
                }
            }
            
            if let maxTransaction = presenter.maxTrasaction {
                sectionMaxTransaction(transaction: maxTransaction)
            }
            
            sectionFirstMaxTrasactionsWeekday
            if let maxTransactionsWeekday = presenter.getMaxWeekday { maxDay in
                DispatchQueue.main.async {
                    if presenter.maxDay.isEmpty { presenter.maxDay = maxDay }
                }
            }, !presenter.maxDay.isEmpty {
                sectionMaxTrasactionsWeekday(daysOfWeek: maxTransactionsWeekday, totalActual: actual)
            }
        }
    }
    
    private func sectionValue(budget: Double, actual: Double) -> some View {
        Section {} footer: {
            valueView(actual: actual, budget: budget)
                .frame(maxWidth: .infinity)
                .padding(.top)
        }
    }
     
    private var sectionOptions: some View {
        CollapsedView(title: presenter.string(.options)) {
            Group {
                HStack {
                    Toggle(isOn: $presenter.isFilterPerDate) {
                        RefdsText(presenter.string(.filterByDate))
                    }
                    .toggleStyle(CheckBoxStyle())
                }
                
                if presenter.isFilterPerDate {
                    PeriodSelectionView(date: $presenter.date, dateFormat: .custom("MMMM, yyyy")) { _ in
                        presenter.loadData()
                    }
                }
            }
        }
    }
    
    private var sectionDifference: some View {
        Section {
            ForEach(presenter.categories) { category in
                NavigationLink(destination: {
                    presenter.router.configure(routes: .transactions(category, presenter.date))
                    
                }, label: {
                    if let budget = presenter.getBudgetAmount(by: category),
                       let actual = presenter.getAmountTransactions(by: category) {
                        rowDifference(category: category, budget: budget, actual: actual)
                    }
                })
            }
        } header: {
            RefdsText(presenter.string(.diff), size: .extraSmall, color: .secondary)
        }
    }
    
    private func sectionValueDifference(budget: Double, actual: Double) -> some View {
        Section { } footer: {
            VStack(alignment: .center, spacing: 10) {
                let totalDifference = presenter.totalDifference
                RefdsText(presenter.string(.totalDiff).uppercased(), size: .custom(12), color: .secondary)
                RefdsText(
                    totalDifference.currency,
                    size: .custom(40),
                    color: totalDifference <= 0 ? .pink : .primary,
                    weight: .bold,
                    family: .moderatMono,
                    alignment: .center,
                    lineLimit: 1
                )
                RefdsText(
                    presenter.getDifferencePercent(budget: budget, actual: actual, hasPlaces: true),
                    size: .custom(20),
                    color: budget > actual ? .accentColor : budget < actual ? .pink : .blue,
                    weight: .bold,
                    family: .moderatMono
                )
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func sectionTransactions(chartData: [(label: String, data: [(category: String, value: Double)])], transactions: [TransactionEntity]) -> some View {
        Section {
            rowTransactions(amount: transactions.count)
            if #available(iOS 16.0, *) {
                rowTransactionChart(chartData: chartData)
            }
        } header: {
            RefdsText(presenter.string(.transactions), size: .extraSmall, color: .secondary)
        }
    }
    
    private func sectionMaxTransaction(transaction: TransactionEntity) -> some View {
        Section {
            VStack {
                HStack {
                    RefdsTag(transaction.date.asString(withDateFormat: .custom("EEE HH:mm")), color: .secondary)
                    RefdsText(transaction.date.asString(withDateFormat: .custom("dd MMMM, yyyy")))
                    Spacer()
                    RefdsTag(transaction.category?.name ?? "", color: transaction.category?.color ?? .accentColor)
                }
                Divider()
                HStack {
                    RefdsText(transaction.description.isEmpty ? presenter.string(.noDescription) : transaction.description, color: .secondary)
                    Spacer()
                    RefdsText(transaction.amount.currency, family: .moderatMono, alignment: .trailing, lineLimit: 1)
                }
            }
        } header: {
            RefdsText(presenter.string(.biggerBuy), size: .extraSmall, color: .secondary)
        }
    }
    
    private var sectionFirstMaxTrasactionsWeekday: some View {
        Section {
            RefdsText(presenter.string(.maxTransactionTitle))
            RefdsText(presenter.string(.maxTransactionDescription), color: .secondary)
        } header: {
            RefdsText(presenter.string(.maxTransactionHeader), size: .extraSmall, color: .secondary)
        }
    }
    
    private func sectionMaxTrasactionsWeekday(daysOfWeek: [String], totalActual: Double) -> some View {
        Section {
            let transactionsWeekday = presenter.transactions(for: presenter.maxDay)
            let amount = transactionsWeekday.map({ $0.amount }).reduce(0, +)
            VStack(alignment: .leading, spacing: 8) {
                if let index = daysOfWeek.firstIndex(of: presenter.maxDay) {
                    RefdsText(presenter.string(.maxTransactionRanking(index + 1)))
                    HStack {
                        Spacer()
                        RefdsText(amount.currency, size: .custom(30), color: .secondary, family: .moderatMono, alignment: .center, lineLimit: 1)
                            .padding(.vertical, 8)
                        Spacer()
                    }
                    RefdsText(presenter.string(.maxTransactionRankingRepresentaion(
                        presenter.getPercent(budget: totalActual, actual: amount, hasPlaces: true),
                        transactionsWeekday.count)
                    ))
                }
            }
            
            CollapsedView(title: presenter.string(.showTransactoins)) {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(transactionsWeekday.indices, id: \.self) { index in
                        let transaction = transactionsWeekday[index]
                        HStack(spacing: 10) {
                            IndicatorPointView(color: transaction.category?.color ?? .secondary)
                            VStack(alignment: .leading, spacing: 5) {
                                RefdsText(transaction.description)
                                HStack {
                                    RefdsText(transaction.date.asString(withDateFormat: .custom("dd MMMM, yyyy - HH:mm")), color: .secondary)
                                    Spacer()
                                    RefdsText(transaction.amount.currency, color: .secondary)
                                }
                            }
                        }
                        if index != transactionsWeekday.count - 1 {
                            Divider().padding(.leading, 25)
                        }
                    }
                }
            }
        } header: {
            SelectionTabView(values: daysOfWeek, selected: $presenter.maxDay)
                .padding(.horizontal, -30)
                .padding(.bottom, 8)
                .padding(.top, -20)
        }
    }
    
    private func valueView(actual: Double, budget: Double) -> some View {
        VStack(spacing: 10) {
            RefdsText(
                presenter.string(.currentValue(presenter.isFilterPerDate ? presenter.date.asString(withDateFormat: .custom("MMMM")).capitalized : "")).uppercased(),
                size: .custom(12),
                color: .secondary
            )
            RefdsText(
                actual.currency,
                size: .custom(40),
                color: budget - actual < 0 ? .pink : .primary,
                weight: .bold,
                family: .moderatMono,
                alignment: .center,
                lineLimit: 1
            )
            RefdsText(budget.currency, size: .custom(20), color: .accentColor, weight: .bold, family: .moderatMono)
        }
    }
    
    private func rowDifference(category: CategoryEntity, budget: Double, actual: Double) -> some View {
        VStack(spacing: 5) {
            HStack {
                RefdsText(category.name.capitalized, weight: .bold)
                Spacer()
                RefdsText((budget - actual).currency, family: .moderatMono)
            }
            HStack(spacing: 10) {
                RefdsText(presenter.getDifferencePercent(budget: budget, actual: actual, hasPlaces: true), color: .secondary)
                let newActual = actual > budget ? budget : actual
                ProgressView(value: newActual, total: budget, label: {  })
                    .tint(presenter.getActualColor(actual: actual, budget: budget))
            }
        }
    }
    
    private func rowTransactions(amount: Int) -> some View {
        HStack {
            RefdsText(presenter.string(.amountTransactionsMoment))
            Spacer()
            GroupBox {
                RefdsText("\(amount)", weight: .bold, family: .moderatMono)
            }
            .listGroupBoxStyle()
        }
    }
    
    @available(iOS 16.0, *)
    private func rowTransactionChart(chartData: [(label: String, data: [(category: String, value: Double)])]) -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                VStack(alignment: .center, spacing: 5) {
                    RefdsText(presenter.string(.transactionsForCategory), weight: .bold)
                    RefdsText(presenter.string(.budgetVsActual), size: .small)
                }
                Spacer()
            }
            TabView {
                sectionChartBar(chartData: chartData)
                sectionChartLine(chartData: chartData)
            }
            .frame(height: 350)
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
    
    @available(iOS 16.0, *)
    private func sectionChartBar(chartData: [(label: String, data: [(category: String, value: Double)])]) -> some View {
        Chart(chartData, id: \.label) { chartData in
            ForEach(chartData.data, id: \.category) {
                BarMark(
                    x: .value(presenter.string(.category), $0.category),
                    y: .value(presenter.string(.value), $0.value)
                )
                .foregroundStyle(by: .value(presenter.string(.category), chartData.label))
                .position(by: .value(presenter.string(.category), chartData.label))
            }
        }
        .chartForegroundStyleScale([
            presenter.string(.budget): Color.teal,
            presenter.string(.current): Color.accentColor
        ])
        .chartLegend(position: .overlay, alignment: .top, spacing: -20)
        .chartYAxis { AxisMarks(position: .leading) }
        .frame(minHeight: 250)
        .padding()
        .padding(.vertical)
        .padding(.vertical)
    }
    
    @available(iOS 16.0, *)
    private func sectionChartLine(chartData: [(label: String, data: [(category: String, value: Double)])]) -> some View {
        Chart {
            ForEach(chartData[1].data, id: \.category) {
                LineMark(
                    x: .value(presenter.string(.category), $0.category),
                    y: .value(presenter.string(.value), $0.value)
                )
                .interpolationMethod(.catmullRom)
                .symbol(by: .value(presenter.string(.category), chartData[1].label))
                .symbolSize(30)
                .foregroundStyle(by: .value(presenter.string(.category), chartData[1].label))
                .position(by: .value(presenter.string(.category), chartData[1].label))
                
                AreaMark(
                    x: .value(presenter.string(.category), $0.category),
                    y: .value(presenter.string(.value), $0.value)
                )
                .interpolationMethod(.catmullRom)
                .symbol(by: .value(presenter.string(.category), chartData[1].label))
                .symbolSize(30)
                .foregroundStyle(Gradient(colors: [.accentColor.opacity(0.5), .accentColor.opacity(0.25)]))
                .position(by: .value(presenter.string(.category), chartData[1].label))
            }
            
            ForEach(chartData[0].data, id: \.category) {
                LineMark(
                    x: .value(presenter.string(.category), $0.category),
                    y: .value(presenter.string(.value), $0.value)
                )
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(dash: [5, 10]))
                .symbol(by: .value(presenter.string(.category), chartData[0].label))
                .symbolSize(30)
                .foregroundStyle(by: .value(presenter.string(.category), chartData[0].label))
                .position(by: .value(presenter.string(.category), chartData[1].label))
            }
        }
        .chartForegroundStyleScale([
            presenter.string(.current): Color.accentColor,
            presenter.string(.budget): Color.teal
        ])
        .chartLegend(position: .overlay, alignment: .top, spacing: -20)
        .chartYAxis { AxisMarks(position: .leading) }
        .frame(minHeight: 250)
        .padding()
        .padding(.vertical)
        .padding(.vertical)
    }
}
