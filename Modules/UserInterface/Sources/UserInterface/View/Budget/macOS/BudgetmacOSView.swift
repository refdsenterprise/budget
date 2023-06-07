//
//  BudgetmacOSView.swift
//  
//
//  Created by Rafael Santos on 12/03/23.
//

import SwiftUI
import RefdsUI
import Charts
import Domain
import Presentation

struct BudgetmacOSView<Presenter: BudgetPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    @State private var isPresentedDiffCategories: Bool = false
    
    var body: some View {
        MacUIView(sections: sections)
            .overlay(alignment: .center) { loading }
            .navigationTitle(presenter.string(.navigationTitle(presenter.isFilterPerDate ? presenter.date.asString(withDateFormat: .custom("MMMM")).capitalized : "")))
            .onAppear { presenter.loadData() }
    }
    
    private var loading: some View {
        Group {
            if presenter.showLoading {
                ProgressView()
            }
        }
    }
    
    private var sections: [MacUISection] {
        presenter.showLoading ? [] : presenter.needShowModalPro ? [
            .init(maxAmount: 2, content: {
                Group {
                    sectionValue
                    sectionOptions
                }
            }),
            .init(content: {
                ProSection()
            })
        ] : [
            .init(maxAmount: 2, content: {
                Group {
                    sectionValue
                    sectionOptions
                }
            }),
            .init(maxAmount: nil, content: {
                Group {
                    if !presenter.viewData.remainingCategory.isEmpty {
                        sectionDifference
                    }
                }
            }),
            .init(maxAmount: 2, content: {
                Group {
                    if !presenter.viewData.remainingCategory.isEmpty {
                        sectionValueDifference
                    }
                    
                    SectionGroup {
                        Group {
                            if presenter.viewData.chart.allSatisfy({ !$0.data.isEmpty }) {
                                rowTransactions
                            }
                            
                            if let maxTransaction = presenter.viewData.biggerBuy {
                                sectionMaxTransaction(transaction: maxTransaction)
                            }
                        }
                    }
                }
            }),
            .init(maxAmount: 1, content: {
                Group {
                    if presenter.viewData.chart.allSatisfy({ !$0.data.isEmpty }) {
                        sectionChart
                    }
                }
            }),
            .init(content: {
                Group {
                    sectionBubbleWords
                    sectionAddBubble
                }
            }),
            .init(maxAmount: 1, content: {
                Group {
                    if !presenter.viewData.bubbleWords.isEmpty {
                        HStack {
                            Spacer()
                            BubbleView(viewData: $presenter.viewData.bubbleWords)
                                .frame(width: 350 * 1.34, height: 350)
                            Spacer()
                        }
                    }
                }
            }),
            .init(maxAmount: 2, content: {
                Group {
                    if !presenter.maxDay.isEmpty { sectionFirstMaxTrasactionsWeekday }
                    if presenter.viewData.weekdaysDetail != nil,
                       !presenter.maxDay.isEmpty { sectionMaxTrasactionsWeekday }
                }
                .padding(.all, 10)
            }),
            .init(maxAmount: 1, content: {
                Group {
                    if !presenter.viewData.weekdays.isEmpty, !presenter.maxDay.isEmpty {
                        SelectionTabView(values: presenter.viewData.weekdays, selected: $presenter.maxDay)
                    }
                }
            }),
            .init(maxAmount: nil, content: {
                Group {
                    if !presenter.viewData.weekdayTransactions.isEmpty {
                        rowShowTransactions
                    }
                }
            })
        ]
    }
    
    private var sectionValue: some View {
        valueView(actual: presenter.viewData.value.totalActual, budget: presenter.viewData.value.totalBudget)
            .frame(maxWidth: .infinity)
            .padding(.top)
    }
    
    private var sectionOptions: some View {
        SectionGroup {
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
                                Spacer()
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
    }
    
    private var sectionDifference: some View {
        ForEach(presenter.viewData.remainingCategory, id: \.id) { category in
            GroupBox {
                rowDifference(category: category)
            }
            .listGroupBoxStyle(isButton: true)
            .onTapGesture { isPresentedDiffCategories.toggle() }
            .navigation(isPresented: $isPresentedDiffCategories, destination: {
                presenter.router.configure(routes: .transactions(category.id, presenter.date))
            })
            .padding(.all, 10)
        }
    }
    
    private var sectionValueDifference: some View {
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
    
    private var sectionChart: some View {
        CollapsedView(showOptions: true, title: presenter.string(.transactions).capitalized, content: {
            Group {
                if #available(iOS 16.0, *), #available(macOS 13.0, *) {
                    rowTransactionChart
                }
            }
        })
        .padding()
    }
    
    private func sectionMaxTransaction(transaction: TransactionViewData.Transaction) -> some View {
        SectionGroup {
            TransactionCardView(transaction: transaction)
        }
    }
    
    private var sectionFirstMaxTrasactionsWeekday: some View {
        SectionGroup(headerTitle: presenter.string(.maxTransactionHeader).capitalized) {
            VStack(alignment: .leading) {
                RefdsText(presenter.string(.maxTransactionTitle))
                Divider()
                RefdsText(presenter.string(.maxTransactionDescription), color: .secondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var sectionMaxTrasactionsWeekday: some View {
        VStack(spacing: 10) {
            rowAnalysisTransactionsWeekday
        }
    }
    
    private var sectionBubbleWords: some View {
        Group {
            if !presenter.viewData.bubbleWords.isEmpty {
                ForEach(presenter.viewData.bubbleWords.indices, id: \.self) { index in
                    GroupBox {
                        rowBubble(index: index)
                    }.listGroupBoxStyle()
                }
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
    
    private var rowAnalysisTransactionsWeekday: some View {
        VStack(spacing: 5) {
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
    }
    
    private var rowShowTransactions: some View {
        ForEach(presenter.viewData.weekdayTransactions, id: \.id) { transaction in
            GroupBox {
                TransactionCardView(transaction: transaction)
            }
            .listGroupBoxStyle()
        }
        .padding(.all, 10)
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
    
    private var sectionAddBubble: some View {
        SectionGroup {
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
                alignment: .trailing
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
    
    @available(macOS 13.0, *)
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
            .frame(height: 350)
            #if os(iOS)
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            #else
            .padding(.top)
            .padding(.top)
            #endif
        }
    }
    
    @available(macOS 13.0, *)
    @available(iOS 16.0, *)
    private var sectionChartBar: some View {
        Chart(presenter.viewData.chart, id: \.label) { chartData in
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
            presenter.string(.budget): Color.blue,
            presenter.string(.current): Color.accentColor
        ])
        .chartLegend(position: .overlay, alignment: .top, spacing: -20)
        .chartYAxis { AxisMarks(position: .leading) }
        .frame(minHeight: 250)
        .padding()
        .padding(.vertical)
        .padding(.vertical)
    }
    
    @available(macOS 13.0, *)
    @available(iOS 16.0, *)
    private var sectionChartLine: some View {
        Chart {
            if presenter.viewData.chart.indices.contains(0),
               presenter.viewData.chart.indices.contains(1) {
                let prevChart = presenter.viewData.chart[0]
                let nextChart = presenter.viewData.chart[1]
                ForEach(nextChart.data, id: \.category) {
                    LineMark(
                        x: .value(presenter.string(.category), $0.category),
                        y: .value(presenter.string(.value), $0.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .symbol(by: .value(presenter.string(.category), nextChart.label))
                    .symbolSize(30)
                    .foregroundStyle(by: .value(presenter.string(.category), nextChart.label))
                    .position(by: .value(presenter.string(.category), nextChart.label))
                    
                    AreaMark(
                        x: .value(presenter.string(.category), $0.category),
                        y: .value(presenter.string(.value), $0.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .symbol(by: .value(presenter.string(.category), nextChart.label))
                    .symbolSize(30)
                    .foregroundStyle(Gradient(colors: [.accentColor.opacity(0.5), .accentColor.opacity(0.25)]))
                    .position(by: .value(presenter.string(.category), nextChart.label))
                }
                
                ForEach(prevChart.data, id: \.category) {
                    LineMark(
                        x: .value(presenter.string(.category), $0.category),
                        y: .value(presenter.string(.value), $0.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(dash: [5, 10]))
                    .symbol(by: .value(presenter.string(.category), prevChart.label))
                    .symbolSize(30)
                    .foregroundStyle(by: .value(presenter.string(.category), prevChart.label))
                    .position(by: .value(presenter.string(.category), nextChart.label))
                }
            }
        }
        .chartForegroundStyleScale([
            presenter.string(.current): Color.accentColor,
            presenter.string(.budget): Color.blue
        ])
        .chartLegend(position: .overlay, alignment: .top, spacing: -20)
        .chartYAxis { AxisMarks(position: .leading) }
        .frame(minHeight: 250)
        .padding()
        .padding(.vertical)
        .padding(.vertical)
    }
}
