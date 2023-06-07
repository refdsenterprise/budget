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
#if os(iOS)
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
        .refreshable { presenter.loadData() }
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
                            RefdsToggle(isOn: $presenter.isFilterPerDate) {
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
            RefdsText(presenter.string(.diff), style: .caption1, color: .secondary)
        }
    }
    
    private var sectionValueDifference: some View {
        Section { } footer: {
            VStack(alignment: .center, spacing: 10) {
                RefdsText(presenter.string(.totalDiff).uppercased(), style: .caption1, color: .secondary)
                RefdsText(
                    presenter.viewData.remainingCategoryValue.amount.currency,
                    style: .superTitle,
                    weight: .bold,
                    alignment: .center,
                    lineLimit: 1
                )
                RefdsText(
                    presenter.viewData.remainingCategoryValue.percentString,
                    style: .title3,
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
            RefdsText(presenter.string(.transactions), style: .caption1, color: .secondary)
        }
    }
    
    private func sectionMaxTransaction(transaction: TransactionViewData.Transaction) -> some View {
        Section {
            TransactionCardView(transaction: transaction)
        } header: {
            RefdsText(presenter.string(.biggerBuy), style: .caption1, color: .secondary)
        }
    }
    
    private var sectionFirstMaxTrasactionsWeekday: some View {
        Section {
        } header: {
            RefdsText(presenter.string(.maxTransactionHeader), style: .caption1, color: .secondary)
        } footer: {
            VStack(alignment: .leading, spacing: 10) {
                RefdsText(presenter.string(.maxTransactionTitle))
                RefdsText(presenter.string(.maxTransactionDescription))
                SelectionTabView(values: presenter.viewData.weekdays, selected: $presenter.maxDay)
                    .padding(.horizontal, -30)
                    .padding(.top)
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
                style: .subheadline,
                color: .secondary
            )
            RefdsText(
                (presenter.viewData.weekdaysDetail?.amount ?? 0).currency,
                style: .superTitle,
                weight: .bold,
                alignment: .center,
                lineLimit: 1
            )
            RefdsText(
                presenter.viewData.weekdaysDetail?.percentString ?? "",
                style: .title3,
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
            RefdsText(presenter.string(.expansesConcentration), style: .caption1, color: .secondary)
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
            CollapsedView(title: presenter.string(.addBubble), description: "\(presenter.viewData.bubbleWords.count)") {
                Group {
                    rowBubbleName
                    rowBubbleColor
                    Button {
                        Application.shared.endEditing()
                        Task { await presenter.addBubble() }
                    } label: {
                        RefdsText(presenter.string(.saveBubble).capitalized, style: .body, color: .accentColor, alignment: .center)
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
            ColorSelection(color: $presenter.bubbleColor).padding(.trailing, -15)
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
                style: .caption1,
                color: .secondary
            )
            RefdsText(
                actual.currency,
                style: .superTitle,
                weight: .bold,
                alignment: .center,
                lineLimit: 1
            )
            RefdsText(budget.currency, style: .title3, color: .accentColor, weight: .bold)
        }
    }
    
    private func rowDifference(category: BudgetViewData.RemainingCategory) -> some View {
        HStack(spacing: 15) {
            RefdsIcon(symbol: category.icon, color: category.color, size: 12, weight: .medium, renderingMode: .hierarchical)
                .frame(width: 18, height: 18)
                .padding(.all, 5)
                .background(category.color.opacity(0.2))
                .cornerRadius(8)
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
                    RefdsText(presenter.string(.budgetVsActual), style: .footnote)
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
#endif
