//
//  BudgetiOSView.swift
//  
//
//  Created by Rafael Santos on 12/03/23.
//

import SwiftUI
import RefdsUI
import Charts
import Domain
import Presentation

struct BudgetiOSView<Presenter: BudgetPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        List {
            if !presenter.showLoading {
                sectionValue
                sectionOptions
                
                if presenter.needShowModalPro {
                    ProSection()
                } else {
                    if !presenter.viewData.remainingCategory.isEmpty {
                        sectionDifference
                        sectionValueDifference
                        
                        if !presenter.viewData.chart.isEmpty {
                            sectionTransactions
                        }
                    }
                    
                    if let maxTransaction = presenter.viewData.biggerBuy {
                        sectionMaxTransaction(transaction: maxTransaction)
                    }
                    
                    if !presenter.viewData.weekdays.isEmpty, !presenter.maxDay.isEmpty {
                        sectionFirstMaxTrasactionsWeekday
                    }
                    
                    if !presenter.viewData.weekdayTransactions.isEmpty {
                        sectionMaxTrasactionsWeekday
                    }
                    
                    if presenter.viewData.value.totalActual > 0 {
                        sectionBubbleWords
                    }
                }
            }
        }
        .navigationTitle(presenter.string(.navigationTitle(presenter.isFilterPerDate ? presenter.date.asString(withDateFormat: .custom("MMMM")).capitalized : "")))
        .onAppear { presenter.loadData() }
        .overlay(alignment: .center) { loading }
    }
    
    private var loading: some View {
        Group {
            if presenter.showLoading {
                ProgressView()
            }
        }
    }
    
    private var sectionValue: some View {
        Section {} footer: {
            valueView(actual: presenter.viewData.value.totalActual, budget: presenter.viewData.value.totalBudget)
                .frame(maxWidth: .infinity)
                .padding(.top)
        }
    }
    
    private var sectionOptions: some View {
        Group {
            if presenter.needShowModalPro {
                HStack {
                    RefdsText(presenter.string(.options))
                    Spacer()
                    ProTag()
                }
            } else {
                CollapsedView(title: presenter.string(.options)) {
                    Group {
                        HStack {
                            Toggle(isOn: $presenter.isFilterPerDate) {
                                RefdsText(presenter.string(.filterByDate))
                            }
                            .tint(.accentColor)
                        }
                        
                        if presenter.isFilterPerDate {
                            PeriodSelectionView(date: $presenter.date, dateFormat: .custom("MMMM, yyyy")) { _ in
                                presenter.loadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var sectionDifference: some View {
        Section {
            ForEach(presenter.viewData.remainingCategory, id: \.id) { category in
                NavigationLink(destination: {
                    presenter.router.configure(routes: .transactions(category.id, presenter.date))
                }, label: {
                    rowDifference(category: category)
                })
            }
        } header: {
            RefdsText(presenter.string(.diff), size: .extraSmall, color: .secondary)
        }
    }
    
    private var sectionValueDifference: some View {
        Section { } footer: {
            VStack(alignment: .center, spacing: 10) {
                RefdsText(presenter.string(.totalDiff).uppercased(), size: .custom(12), color: .secondary)
                RefdsText(
                    presenter.viewData.remainingCategoryValue.amount.currency,
                    size: .custom(40),
                    weight: .bold,
                    alignment: .center,
                    lineLimit: 1
                )
                RefdsText(
                    presenter.viewData.remainingCategoryValue.percentString,
                    size: .custom(20),
                    color: presenter.viewData.remainingCategoryValue.color,
                    weight: .bold
                )
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var sectionTransactions: some View {
        Section {
            rowTransactions
            if #available(iOS 16.0, *) {
                rowTransactionChart
            }
        } header: {
            RefdsText(presenter.string(.transactions), size: .extraSmall, color: .secondary)
        }
    }
    
    private func sectionMaxTransaction(transaction: TransactionViewData.Transaction) -> some View {
        Section {
            TransactionCardView(transaction: transaction)
        } header: {
            RefdsText(presenter.string(.biggerBuy), size: .extraSmall, color: .secondary)
        }
    }
    
    private var sectionFirstMaxTrasactionsWeekday: some View {
        Section {
        } header: {
            RefdsText(presenter.string(.maxTransactionHeader), size: .extraSmall, color: .secondary)
        } footer: {
            VStack {
                HStack {
                    RefdsText(presenter.string(.maxTransactionTitle))
                    Spacer()
                }
                .padding(.horizontal, -15)
                
                HStack {
                RefdsText(presenter.string(.maxTransactionDescription), color: .secondary)
                    Spacer()
                }
                .padding(.horizontal, -15)
                SelectionTabView(values: presenter.viewData.weekdays, selected: $presenter.maxDay)
                    .padding(.horizontal, -30)
                    .padding(.top, 10)
                rowAnalysisTransactions
                    .padding()
            }
        }
    }
    
    private var sectionMaxTrasactionsWeekday: some View {
        Section {
            rowShowTransactions
        }
    }
    
    private var rowAnalysisTransactions: some View {
        VStack(alignment: .center, spacing: 5) {
            RefdsText(
                presenter.string(.maxTransactionRanking(presenter.viewData.weekdaysDetail?.amountTransactions ?? 0)).uppercased(),
                size: .custom(15),
                color: .secondary
            )
            RefdsText(
                (presenter.viewData.weekdaysDetail?.amount ?? 0).currency,
                size: .custom(40),
                weight: .bold,
                alignment: .center,
                lineLimit: 1
            )
            RefdsText(
                presenter.viewData.weekdaysDetail?.percentString ?? "",
                size: .custom(20),
                color: .accentColor,
                weight: .bold
            )
        }
        .frame(maxWidth: .infinity)
    }
    
    private var sectionBubbleWords: some View {
        Section {
            CollapsedView(title: presenter.string(.concentrationValue)) {
                Group {
                    ForEach(presenter.viewData.bubbleWords.indices, id: \.self) { index in
                        rowBubble(index: index)
                            .contextMenu(menuItems: { contextMenuRemoveBubble(presenter.viewData.bubbleWords[index]) })
                            .swipeActions(edge: .trailing, allowsFullSwipe: true, content: { swipeRemoveBubble(presenter.viewData.bubbleWords[index]) })
                    }
                    sectionAddBubble
                }
            }
        } header: {
            RefdsText(presenter.string(.expansesConcentration), size: .extraSmall, color: .secondary)
        } footer: {
            if !presenter.viewData.bubbleWords.isEmpty {
                BubbleView(viewData: $presenter.viewData.bubbleWords)
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                    .padding(.bottom, -20)
            }
        }
    }
    
    private func rowBubble(index: Int) -> some View {
        VStack(spacing: 5) {
            let item = presenter.viewData.bubbleWords[index]
            HStack(spacing: 10) {
                IndicatorPointView(color: item.color)
                RefdsText(item.title.capitalized)
                Spacer()
                RefdsText(item.realValue.currency, color: .secondary)
            }
        }
    }
    
    private var sectionAddBubble: some View {
        Section {
            CollapsedView(title: "Adicionar Bolha", description: "\(presenter.viewData.bubbleWords.count)") {
                Group {
                    rowBubbleName
                    rowBubbleColor
                    Button {
                        Application.shared.endEditing()
                        Task { await presenter.addBubble() }
                    } label: {
                        RefdsText("Salvar Bolha".uppercased(), size: .extraSmall, color: .accentColor, weight: .bold, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    private var rowBubbleName: some View {
        HStack {
            RefdsText(presenter.string(.labelBubbleName))
            RefdsTextField(
                presenter.string(.labelPlaceholderName),
                text: $presenter.bubbleName,
                alignment: .trailing,
                textInputAutocapitalization: .characters
            )
        }
    }
    
    private var rowBubbleColor: some View {
        HStack {
            RefdsText(presenter.string(.labelBubbleColor))
            Spacer()
            ColorPicker(
                selection: $presenter.bubbleColor,
                supportsOpacity: false
            ) {}
        }
    }
    
    private func swipeRemoveBubble(_ bubble: BudgetViewData.Bubble) -> some View {
        Button {
            Task { await presenter.removeBubble(id: bubble.id) }
        } label: {
            RefdsIcon(
                symbol: .trashFill,
                color: .white,
                size: 25,
                renderingMode: .hierarchical
            )
        }
        .tint(.red)
    }
    
    private func contextMenuRemoveBubble(_ bubble: BudgetViewData.Bubble) -> some View {
        Button {
            Task { await presenter.removeBubble(id: bubble.id) }
        } label: {
            Label("Remover", systemImage: RefdsIconSymbol.trashFill.rawValue)
        }
    }
    
    private var rowShowTransactions: some View {
        CollapsedView(title: presenter.string(.showTransactoins)) {
            ForEach(presenter.viewData.weekdayTransactions, id: \.id) { transaction in
                TransactionCardView(transaction: transaction)
            }
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
                weight: .bold,
                alignment: .center,
                lineLimit: 1
            )
            RefdsText(budget.currency, size: .custom(20), color: .accentColor, weight: .bold)
        }
    }
    
    private func rowDifference(category: BudgetViewData.RemainingCategory) -> some View {
        VStack(spacing: 5) {
            HStack {
                RefdsText(category.name.capitalized, weight: .bold)
                Spacer()
                RefdsText(category.value.currency)
            }
            HStack(spacing: 10) {
                RefdsText(category.percentString, color: .secondary)
                ProgressView(value: category.percent, total: 100, label: {  })
                    .tint(category.percentColor)
            }
        }
    }
    
    private var rowTransactions: some View {
        HStack {
            RefdsText(presenter.string(.amountTransactionsMoment))
            Spacer()
            GroupBox {
                RefdsText("\(presenter.viewData.amountTransactions)", weight: .bold)
            }
        }
    }
    
    @available(iOS 16.0, *)
    private var rowTransactionChart: some View {
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
                sectionChartBar
                sectionChartLine
            }
            .frame(height: 400)
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
    
    @available(iOS 16.0, *)
    private var sectionChartBar: some View {
        Chart(presenter.viewData.chart, id: \.label) { chartData in
            ForEach(chartData.data, id: \.category) {
                BarMark(
                    x: .value(presenter.string(.category), String($0.category.prefix(3))),
                    y: .value(presenter.string(.value), $0.value)
                )
                .foregroundStyle(by: .value(presenter.string(.category), chartData.label))
                .position(by: .value(presenter.string(.category), chartData.label))
            }
        }
        .chartForegroundStyleScale([
            presenter.string(.budget): Color.blue,
            presenter.string(.current): Color.green
        ])
        .chartLegend(position: .overlay, alignment: .top, spacing: -20)
        .chartYAxis { AxisMarks(position: .leading) }
        .frame(minHeight: 300)
        .padding()
        .padding(.vertical)
        .padding(.vertical)
    }
    
    @available(iOS 16.0, *)
    private var sectionChartLine: some View {
        Chart {
            if presenter.viewData.chart.indices.contains(0) && presenter.viewData.chart.indices.contains(1) {
                ForEach(presenter.viewData.chart[1].data, id: \.category) {
                    LineMark(
                        x: .value(presenter.string(.category), String($0.category.prefix(3))),
                        y: .value(presenter.string(.value), $0.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .symbol(by: .value(presenter.string(.category), presenter.viewData.chart[1].label))
                    .symbolSize(30)
                    .foregroundStyle(by: .value(presenter.string(.category), presenter.viewData.chart[1].label))
                    .position(by: .value(presenter.string(.category), presenter.viewData.chart[1].label))
                    
                    AreaMark(
                        x: .value(presenter.string(.category), String($0.category.prefix(3))),
                        y: .value(presenter.string(.value), $0.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .symbol(by: .value(presenter.string(.category), presenter.viewData.chart[1].label))
                    .symbolSize(30)
                    .foregroundStyle(Gradient(colors: [.accentColor.opacity(0.5), .accentColor.opacity(0.25)]))
                    .position(by: .value(presenter.string(.category), presenter.viewData.chart[1].label))
                }
                
                ForEach(presenter.viewData.chart[0].data, id: \.category) {
                    LineMark(
                        x: .value(presenter.string(.category), String($0.category.prefix(3))),
                        y: .value(presenter.string(.value), $0.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(dash: [5, 10]))
                    .symbol(by: .value(presenter.string(.category), presenter.viewData.chart[0].label))
                    .symbolSize(30)
                    .foregroundStyle(by: .value(presenter.string(.category), presenter.viewData.chart[0].label))
                    .position(by: .value(presenter.string(.category), presenter.viewData.chart[1].label))
                }
            }
        }
        .chartForegroundStyleScale([
            presenter.string(.current): Color.green,
            presenter.string(.budget): Color.blue
        ])
        .chartLegend(position: .overlay, alignment: .top, spacing: -20)
        .chartYAxis { AxisMarks(position: .leading) }
        .frame(minHeight: 300)
        .padding()
        .padding(.vertical)
        .padding(.vertical)
    }
}
