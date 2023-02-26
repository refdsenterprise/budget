//
//  BudgetScene.swift
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

public struct BudgetScene: View {
    @StateObject private var presenter: BudgetPresenter = .instance
    @State private var selection: Int = 0
    @State private var maxDay: String = ""
    @State private var showDatePicker = false
    @Environment(\.colorScheme) var colorScheme
    
    private let transactionScene: (CategoryEntity, Date) -> any View
    
    public init(transactionScene: @escaping (CategoryEntity, Date) -> any View) {
        self.transactionScene = transactionScene
    }
    
    public var body: some View {
        content
            .navigationTitle("Budget" + " \(presenter.isFilterPerDate ? presenter.date.asString(withDateFormat: .custom("MMMM")).capitalized : "")")
            .onAppear { presenter.loadData() }
    }
    
    private var content: some View {
        List {
            let actual = presenter.getTotalActual()
            let budget = presenter.getTotalBudget()
            Section {} footer: {
                valueView(actual: actual, budget: budget)
                    .frame(maxWidth: .infinity)
                    .padding(.top)
            }
            
            CollapsedView(title: "Opções") {
                sectionOptions
            }
            
            if !presenter.categories.isEmpty {
                sectionDifference
                sectionTotalDifference(budget: budget, actual: actual)
                
                if #available(iOS 16.0, *), let chartData = presenter.getChartData(), !chartData.flatMap({ $0.data }).isEmpty {
                    Section {
                        if let transctions = presenter.getTransactions() {
                            HStack {
                                RefdsText("Quantidade de transações realizadas até o momento")
                                Spacer()
                                Group {
                                    RefdsText("\(transctions.count)", weight: .bold, family: .moderatMono)
                                }
                                .padding()
                                .background(colorScheme == .dark ? Color(uiColor: .systemBackground) : Color(uiColor: .secondarySystemBackground))
                                .cornerRadius(8)
                            }
                        }
                        VStack(spacing: 0) {
                            HStack {
                                Spacer()
                                VStack(alignment: .center, spacing: 5) {
                                    RefdsText("Trasações Por Categoria", weight: .bold)
                                    RefdsText("Budget x Atual", size: .small)
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
                    } header: {
                        RefdsText("transações", size: .extraSmall, color: .secondary)
                    }
                }
                
                if let maxTransaction = presenter.getMaxTrasaction() {
                    sectionMaxTransaction(transaction: maxTransaction)
                }
                
                sectionFirstMaxTrasactionsWeekday
                if let maxTransactionsWeekday = presenter.getMaxWeekday { maxDay in
                    DispatchQueue.main.async {
                        if self.maxDay.isEmpty { self.maxDay = maxDay }
                    }
                }, let totalActual = presenter.getTotalActual(), !maxDay.isEmpty {
                    sectionMaxTrasactionsWeekday(daysOfWeek: maxTransactionsWeekday, totalActual: totalActual)
                }
            }
        }
    }
    
    private var sectionOptions: some View {
        Group {
            HStack {
                Toggle(isOn: Binding(get: { presenter.isFilterPerDate }, set: { presenter.isFilterPerDate = $0; presenter.loadData() })) { RefdsText("Filtrar por data") }
            }
            if presenter.isFilterPerDate {
                Button {
                    withAnimation {
                        showDatePicker.toggle()
                    }
                } label: {
                    HStack(spacing: 15) {
                        RefdsText("Periodo")
                        Spacer()
                        RefdsTag(presenter.date.asString(withDateFormat: .custom("MMMM, yyyy")), color: .accentColor)
                    }
                }
            }
            if showDatePicker {
                DatePicker(selection: Binding(get: { presenter.date }, set: { presenter.date = $0; presenter.loadData() }), displayedComponents: .date) {
                    EmptyView()
                }
                .datePickerStyle(.graphical)
                .onChange(of: presenter.date) { _ in
                    withAnimation {
                        showDatePicker.toggle()
                    }
                }
            }
        }
    }
    
    private var pageBudget: some View {
        VStack {
            TabView(selection: Binding(get: {
                selection
            }, set: { value, _ in
                selection = value
                if let period = PeriodEntity(rawValue: Int(value)) {
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
            RefdsText("valor atual \(presenter.isFilterPerDate ? presenter.date.asString(withDateFormat: .custom("MMMM")).capitalized : "")".uppercased(), size: .custom(12), color: .secondary)
            RefdsText(
                actual.formatted(.currency(code: "BRL")),
                size: .custom(40),
                color: budget - actual < 0 ? .pink : .primary,
                weight: .bold,
                family: .moderatMono,
                alignment: .center,
                lineLimit: 1
            )
            RefdsText(budget.formatted(.currency(code: "BRL")), size: .custom(20), color: .accentColor, weight: .bold, family: .moderatMono)
        }
    }
    
    private var sectionDifference: some View {
        Section {
            ForEach(presenter.categories) { category in
                NavigationLink(destination: { AnyView(transactionScene(category, presenter.date)) }, label: {
                    if let budget = presenter.getBudgetAmount(by: category),
                       let actual = presenter.getAmountTransactions(by: category) {
                        VStack(spacing: 5) {
                            HStack {
                                RefdsText(category.name.capitalized, weight: .bold)
                                Spacer()
                                RefdsText((budget - actual).formatted(.currency(code: "BRL")), family: .moderatMono)
                            }
                            HStack(spacing: 10) {
                                RefdsText(presenter.getDifferencePercent(budget: budget, actual: actual), color: .secondary)
                                let newActual = actual > budget ? budget : actual
                                ProgressView(value: newActual, total: budget, label: {  })
                                    .tint(presenter.getActualColor(actual: actual, budget: budget))
                            }
                        }
                    }
                })
            }
        } header: {
            if !presenter.categories.isEmpty {
                RefdsText("restante", size: .extraSmall, color: .secondary)
            }
        }
    }
    
    private func sectionTotalDifference(budget: Double, actual: Double) -> some View {
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
    
    @available(iOS 16.0, *)
    private func sectionChartBar(chartData: [(label: String, data: [(category: String, value: Double)])]) -> some View {
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
        .frame(minHeight: 250)
        .padding()
        .padding(.vertical)
        .padding(.vertical)
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
                    RefdsText(transaction.description.isEmpty ? "Sem descrição" : transaction.description, color: .secondary)
                    Spacer()
                    RefdsText(transaction.amount.formatted(.currency(code: "BRL")), family: .moderatMono, alignment: .trailing, lineLimit: 1)
                }
            }
        } header: {
            RefdsText("maior compra", size: .extraSmall, color: .secondary)
        }
    }
    
    private var sectionFirstMaxTrasactionsWeekday: some View {
        Section {
            RefdsText("Nessa área é possível acompanhar seus gastos por dias da semana.")
            RefdsText("Lembrando que está por ordem de maior gasto.", color: .secondary)
        } header: {
            RefdsText("resumo dos dias da semana", size: .extraSmall, color: .secondary)
        }
    }
    
    private func sectionMaxTrasactionsWeekday(daysOfWeek: [String], totalActual: Double) -> some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                if !maxDay.isEmpty {
                    if let index = daysOfWeek.firstIndex(of: maxDay),
                       let transactionsWeekday = presenter.getTransactionsWeekday(weekday: maxDay), let amount = transactionsWeekday.map({ $0.amount }).reduce(0, +) {
                        RefdsText("Esse dia da semana está em \(index + 1)º lugar dos dias com  mais gastos, totalizando:")
                        HStack {
                            Spacer()
                            RefdsText(amount.formatted(.currency(code: "BRL")), size: .custom(30), color: .secondary, family: .moderatMono, alignment: .center, lineLimit: 1)
                                .padding(.vertical, 8)
                            Spacer()
                        }
                        RefdsText("O qual representa \(presenter.getPercent(budget: totalActual, actual: amount, hasPlaces: true)) do gasto mensal. Sendo composto por \(transactionsWeekday.count) transações")
                        Divider()
                        CollapsedView(title: "Exibir transações") {
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
                                                RefdsText(transaction.amount.formatted(.currency(code: "BRL")), color: .secondary)
                                            }
                                        }
                                    }
                                    if index != transactionsWeekday.count - 1 {
                                        Divider().padding(.leading, 25)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
        } header: {
            if !maxDay.isEmpty {
                SelectionTabView(values: daysOfWeek, selected: $maxDay)
                    .padding(.horizontal, -30)
                    .padding(.bottom, 8)
                    .padding(.top, -20)
            }
        }
    }
}

struct BudgetScene_Previews: PreviewProvider {
    static var previews: some View {
        BudgetScene { _, _ in EmptyView() }
    }
}
