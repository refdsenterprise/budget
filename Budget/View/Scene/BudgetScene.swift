//
//  BudgetScene.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI
import Charts
import RefdsCore

struct BudgetScene: View {
    @StateObject private var presenter: BudgetPresenter = .instance
    @State private var selection: Int = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        content
            .navigationTitle(BudgetApp.TabItem.budget.title + " \(presenter.isFilterPerDate ? presenter.selectedPeriod.label.capitalized : "")")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if presenter.isFilterPerDate {
                        RefdsTag(presenter.date.asString(withDateFormat: "dd MMMM, yyyy"), color: .teal)
                    }
                }
            }
            .onAppear { presenter.loadData() }
    }
    
    private var content: some View {
        List {
            if let actual = presenter.getTotalActual(),
               let budget = presenter.getTotalBudget() {
                Section {} footer: {
                    valueView(actual: actual, budget: budget)
                        .padding(.top)
                        .frame(maxWidth: .infinity)
                }
            }
            
            if !presenter.categories.isEmpty {
                sectionDifference
                sectionTotalDifference
                if #available(iOS 16.0, *) { sectionChartBudgetVsActual }
                if let actual = presenter.getTotalActual(),
                   let budget = presenter.getTotalBudget() {
                    sectionBudgetUse(actual: actual, budget: budget)
                }
                sectionCompare
                if let maxTransaction = presenter.getMaxTrasaction() {
                    sectionMaxTransaction(transaction: maxTransaction)
                }
            }
            sectionOptions
        }
    }
    
    private var sectionOptions: some View {
        Section {
            HStack {
                Toggle(isOn: Binding(get: { presenter.isFilterPerDate }, set: { presenter.isFilterPerDate = $0; presenter.loadData() })) { RefdsText("Filtrar por data") }
            }
            if presenter.isFilterPerDate {
                DatePicker(selection: Binding(get: { presenter.date }, set: { presenter.date = $0; presenter.loadData() }), displayedComponents: .date) {
                    RefdsText("Data")
                }
            }
        } header: {
            RefdsText("opções", size: .extraSmall, color: .secondary)
        }
    }
    
    private var pageBudget: some View {
        VStack {
            TabView(selection: Binding(get: {
                selection
            }, set: { value, _ in
                selection = value
                if let period = BudgetPresenter.Period(rawValue: Int(value)) {
                    presenter.selectedPeriod = period
                }
            })) {
                ForEach(0 ..< 3) { i in
                    currentValueView
                        .tag(i)
                }
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .padding(.horizontal, -25)
            .tabViewStyle(PageTabViewStyle())
        }
    }
    
    private var currentValueView: some View {
        VStack {
            if let actual = presenter.getTotalActual(),
               let budget = presenter.getTotalBudget() {
                if presenter.isFilterPerDate {
                    valueView(actual: actual, budget: budget)
                        .padding()
                        .background(Color(uiColor: colorScheme == .dark ? .secondarySystemBackground : .systemBackground))
                        .cornerRadius(15)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func valueView(actual: Double, budget: Double) -> some View {
        VStack(spacing: 10) {
            RefdsText("valor atual \(presenter.isFilterPerDate ? presenter.selectedPeriod.label : "")".uppercased(), size: .custom(12), color: .secondary)
            RefdsText(
                actual.formatted(.currency(code: "BRL")),
                size: .custom(40),
                color: budget - actual < 0 ? .pink : .primary,
                weight: .bold,
                family: .moderatMono,
                alignment: .center,
                lineLimit: 1
            )
            RefdsText(budget.formatted(.currency(code: "BRL")), size: .custom(16), color: .accentColor, weight: .bold, family: .moderatMono)
        }
    }
    
    private var sectionDifference: some View {
        Section {
            ForEach(presenter.categories) { category in
                if let budget = presenter.getBudgetAmount(by: category),
                   let actual = presenter.getAmountTransactions(by: category) {
                    HStack {
                        RefdsTag(presenter.getDifferencePercent(budget: budget, actual: actual), size: .custom(13), color: category.color, lineLimit: 1)
                        RefdsText(category.name.capitalized)
                        Spacer()
                        RefdsText((budget - actual).formatted(.currency(code: "BRL")), color: budget - actual < 0 ? .pink : .secondary, family: .moderatMono)
                    }
                }
            }
        } header: {
            if !presenter.categories.isEmpty {
                RefdsText("restante", size: .extraSmall, color: .secondary)
            }
        }
    }
    
    private var sectionCompare: some View {
        Section {
            ForEach(presenter.categories) { category in
                if let budget = presenter.getBudgetAmount(by: category),
                   let actual = presenter.getAmountTransactions(by: category) {
                    HStack {
                        RefdsText(budget.formatted(.currency(code: "BRL")), color: .primary, family: .moderatMono, alignment: .leading)
                        Spacer()
                        RefdsText(actual.formatted(.currency(code: "BRL")), color: presenter.getActualColor(actual: actual, budget: budget), family: .moderatMono, alignment: .trailing)
                    }
                    .background(alignment: .center) {
                        HStack {
                            Spacer()
                            Button(action: { presenter.isSelectedVersus.toggle() }) {
                                if presenter.isSelectedVersus {
                                    RefdsTag(category.name, size: .custom(11), color: category.color)
                                } else {
                                    RefdsTag("vs", size: .custom(12), color: .secondary)
                                }
                            }
                            Spacer()
                        }
                    }
                    .background {
                        ProgressView(value: actual, total: budget, label: {  })
                            .tint(presenter.getActualColor(actual: actual, budget: budget))
                            .offset(y: 25)
                    }
                    .padding(.bottom)
                    .padding(.top, 5)
                }
            }
        } header: {
            if !presenter.categories.isEmpty {
                HStack {
                    RefdsText("budget", size: .extraSmall, color: .secondary)
                    Spacer()
                    RefdsText("atual", size: .extraSmall, color: .secondary)
                }
            }
        }
    }
    
    private func sectionBudgetUse(actual: Double, budget: Double) -> some View {
        Section {} header: {
            VStack(spacing: 10) {
                RefdsText("percentual de economia".uppercased(), size: .custom(12), color: .secondary)
                RefdsText(
                    presenter.getDifferencePercent(budget: budget, actual: actual, hasPlaces: true),
                    size: .custom(40),
                    color: .primary,
                    weight: .bold,
                    family: .moderatMono,
                    alignment: .center,
                    lineLimit: 1
                )
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var sectionTotalDifference: some View {
        Section { } footer: {
            VStack(alignment: .center, spacing: 10) {
                RefdsText("total restante".uppercased(), size: .custom(12), color: .secondary)
                RefdsText(
                    presenter.getTotalDifference().formatted(.currency(code: "BRL")),
                    size: .custom(40),
                    color: presenter.getTotalDifference() <= 0 ? .pink : .primary,
                    weight: .bold,
                    family: .moderatMono,
                    alignment: .center,
                    lineLimit: 1
                )
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    @available(iOS 16.0, *)
    private var sectionChartBudgetVsActual: some View {
        Section {
            if let chartData = presenter.getChartData(), !chartData.flatMap({ $0.data }).isEmpty {
                VStack(spacing: 10) {
                    Chart(chartData, id: \.label) { chartData in
                        ForEach(chartData.data, id: \.category) {
                            BarMark(
                                x: .value("Category", $0.category),
                                y: .value("Value", $0.value)
                            )
                            .foregroundStyle(by: .value("category", chartData.label))
                            .position(by: .value("category", chartData.label))
                        }
                    }
                    .chartForegroundStyleScale([
                        "Budget": Color.teal,
                        "Atual": Color.accentColor
                    ])
                    .chartLegend(position: .overlay, alignment: .top, spacing: -20)
                    .chartYAxis { AxisMarks(position: .leading) }
                    .frame(minHeight: 150)
                    .padding()
                    .padding(.top)
                    
                    Divider()
                    
                    Chart {
                        ForEach(chartData[1].data, id: \.category) {
                            LineMark(
                                x: .value("Category", $0.category),
                                y: .value("Value", $0.value)
                            )
                            .interpolationMethod(.catmullRom)
                            .symbol(by: .value("category", chartData[1].label))
                            .symbolSize(30)
                            .foregroundStyle(by: .value("category", chartData[1].label))
                            .position(by: .value("category", chartData[1].label))
                            
                            AreaMark(
                                x: .value("Category", $0.category),
                                y: .value("Value", $0.value)
                            )
                            .interpolationMethod(.catmullRom)
                            .symbol(by: .value("category", chartData[1].label))
                            .symbolSize(30)
                            .foregroundStyle(Gradient(colors: [.accentColor.opacity(0.5), .accentColor.opacity(0.25)]))
                            .position(by: .value("category", chartData[1].label))
                        }
                        
                        ForEach(chartData[0].data, id: \.category) {
                            LineMark(
                                x: .value("Category", $0.category),
                                y: .value("Value", $0.value)
                            )
                            .interpolationMethod(.catmullRom)
                            .lineStyle(StrokeStyle(dash: [5, 10]))
                            .symbol(by: .value("category", chartData[0].label))
                            .symbolSize(30)
                            .foregroundStyle(by: .value("category", chartData[0].label))
                            .position(by: .value("category", chartData[1].label))
                        }
                    }
                    .chartForegroundStyleScale([
                        "Atual": Color.accentColor,
                        "Budget": Color.teal
                    ])
                    .chartLegend(position: .overlay, alignment: .top, spacing: -20)
                    .chartYAxis { AxisMarks(position: .leading) }
                    .frame(minHeight: 150)
                    .padding()
                    .padding(.top)
                }
            }
        } header: {
            if !presenter.categories.isEmpty {
                RefdsText("Budget vs Atual", size: .extraSmall, color: .secondary)
            }
        }
    }
    
    private func sectionMaxTransaction(transaction: TransactionEntity) -> some View {
        Section {
            VStack {
                HStack {
                    RefdsText(transaction.date.asString(withDateFormat: "dd MMMM, yyyy - HH:mm"))
                    Spacer()
                    RefdsTag(transaction.category?.name ?? "", color: transaction.category?.color ?? .accentColor)
                }
                Divider()
                HStack {
                    RefdsText(transaction.description.isEmpty ? "Sem descrição" : transaction.description, color: .secondary)
                    Spacer()
                    RefdsText(transaction.amount.formatted(.currency(code: "BRL")), color: .accentColor, weight: .bold, family: .moderatMono, alignment: .trailing, lineLimit: 1)
                }
            }
        } header: {
            RefdsText("maior compra", size: .extraSmall, color: .secondary)
        }
    }
    
    @available(iOS 16.0, *)
    private func sectionChartTransactions(_ chartData: [(date: Date, value: Double)]) -> some View {
        Section {
            Chart {
                ForEach(chartData, id: \.date) {
                    buildLineMarkTransactions($0)
                    buildAreaMarkTransactions($0)
                }
            }
            .chartLegend(position: .overlay, alignment: .top, spacing: -20)
            .chartYAxis { AxisMarks(position: .leading) }
            .frame(minHeight: 150)
            .padding()
            .padding(.top)
            
        } header: {
            RefdsText("transações", size: .extraSmall, color: .secondary)
        }
    }
    
    @available(iOS 16.0, *)
    func buildLineMarkTransactions(_ data: (date: Date, value: Double)) -> some ChartContent {
        LineMark(
            x: .value("date", data.date),
            y: .value("value", data.value)
        )
        .interpolationMethod(.catmullRom)
        .lineStyle(StrokeStyle(dash: [5, 10]))
        .foregroundStyle(by: .value("date", data.date))
        .position(by: .value("date", data.date))
    }
    
    @available(iOS 16.0, *)
    func buildAreaMarkTransactions(_ data: (date: Date, value: Double)) -> some ChartContent {
        AreaMark(
            x: .value("date", data.date),
            y: .value("value", data.value)
        )
        .interpolationMethod(.catmullRom)
        .foregroundStyle(Gradient(colors: [.accentColor.opacity(0.5), .accentColor.opacity(0.25)]))
        .position(by: .value("date", data.date))
    }
}

struct BudgetScene_Previews: PreviewProvider {
    static var previews: some View {
        BudgetScene()
    }
}
