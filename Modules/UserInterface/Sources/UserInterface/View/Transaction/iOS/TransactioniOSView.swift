//
//  TransactioniOSView.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import SwiftUI
import RefdsUI
import Charts
import Domain
import Presentation

struct TransactioniOSView<Presenter: TransactionPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        List {
            sectionOptions
            
            if !presenter.showLoading {
                sectionTotal
                
                if #available(iOS 16.0, *),
                   !presenter.viewData.chart.isEmpty {
                    if presenter.isPro {
                        CollapsedView(title: presenter.string(.chart)) {
                            sectionChartTransactions
                        }
                    } else {
                        HStack {
                            RefdsText(presenter.string(.chart))
                            Spacer()
                            ProTag()
                        }
                    }
                }
                
                if !presenter.viewData.transactions.isEmpty {
                    sectionTransactions
                }
            }
        }
        .listStyle(.insetGrouped)
        .budgetAlert($presenter.alert)
        .navigationTitle(presenter.string(.navigationTitle))
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { buttonAddTransaction } }
        .searchable(text: $presenter.query, prompt: presenter.string(.searchForTransactions))
        .onAppear { presenter.loadData() }
        .overlay(alignment: .center) { loading }
        .navigation(isPresented: $presenter.isPresentedAddTransaction) {
            presenter.router.configure(routes: .addTransaction(nil))
        }
        .navigation(isPresented: $presenter.isPresentedEditTransaction) {
            presenter.router.configure(routes: .addTransaction(presenter.transaction))
        }
    }
    
    private var loading: some View {
        Group {
            if presenter.showLoading {
                ProgressView()
            }
        }
    }
    
    private var sectionOptions: some View {
        Group {
            if !presenter.isPro {
                HStack {
                    RefdsText(presenter.string(.options))
                    Spacer()
                    ProTag()
                }
            } else {
                CollapsedView(title: presenter.string(.options)) {
                    Group {
                        Toggle(isOn: $presenter.isFilterPerDate) {
                            RefdsText(presenter.string(.filterPerDate))
                        }
                        .toggleStyle(CheckBoxStyle())
                        
                        if presenter.isFilterPerDate {
                            CollapsedView(title: presenter.string(.period), description: presenter.selectedPeriod.label.capitalized) {
                                ForEach(PeriodItem.allCases, id: \.self) { period in
                                    Button { presenter.selectedPeriod = period  } label: {
                                        HStack(spacing: 15) {
                                            IndicatorPointView(color: presenter.selectedPeriod == period ? .accentColor : .secondary)
                                            RefdsText(period.label.capitalized, color: .secondary)
                                        }
                                    }
                                }
                            }
                            
                            PeriodSelectionView(date: $presenter.date, dateFormat: .custom("dd MMMM, yyyy"))
                        }
                    }
                }
            }
        }
    }
    
    private var sectionTotal: some View {
        Section {} header: {
            VStack(spacing: 10) {
                RefdsText(
                    presenter.string(.totalTransactions).uppercased(),
                    size: .custom(12),
                    color: .secondary
                )
                RefdsText(
                    presenter.viewData.value.value.currency,
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
    
    private var sectionTransactions: some View {
        ForEach(presenter.viewData.transactions, id: \.id) { transaction in
            Section {
                VStack {
                    rowTransactionTop(transaction)
                    Divider()
                    rowTransactionBottom(transaction)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    swipeEdit(transaction: transaction)
                    swipeRemove(transaction: transaction)
                }
                .contextMenu {
                    contextMenuEdit(transaction: transaction)
                    contextMenuRemove(transaction: transaction)
                }
            }
        }
    }
    
    private func rowTransactionTop(_ transaction: TransactionViewData.Transaction) -> some View {
        HStack {
            RefdsTag(transaction.date.asString(withDateFormat: .custom("EEE HH:mm")), color: .secondary)
            RefdsText(transaction.date.asString(withDateFormat: .custom("dd MMMM, yyyy")))
            Spacer()
            RefdsTag(transaction.categoryName, color: transaction.categoryColor)
        }
    }
    
    private func rowTransactionBottom(_ transaction: TransactionViewData.Transaction) -> some View {
        HStack {
            RefdsText(transaction.description.isEmpty ? presenter.string(.noDescription) : transaction.description, color: .secondary)
            Spacer()
            RefdsText(transaction.amount.currency, family: .moderatMono, alignment: .trailing, lineLimit: 1)
        }
    }
    
    private func swipeRemove(transaction: TransactionViewData.Transaction) -> some View {
        Button {
            withAnimation {
                presenter.remove(transaction: transaction.id) {
                    presenter.alert = .init(error: $0)
                }
            }
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
    
    private func swipeEdit(transaction: TransactionViewData.Transaction) -> some View {
        Button {
            withAnimation {
                presenter.transaction = transaction.id
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    presenter.isPresentedEditTransaction.toggle()
                }
            }
        } label: {
            RefdsIcon(
                symbol: .squareAndPencil,
                color: .white,
                size: 25,
                renderingMode: .hierarchical
            )
        }
        .tint(.orange)
    }
    
    private func contextMenuEdit(transaction: TransactionViewData.Transaction) -> some View {
        Button {
            withAnimation {
                presenter.transaction = transaction.id
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    presenter.isPresentedEditTransaction.toggle()
                }
            }
        } label: {
            Label(presenter.string(.edit), systemImage: RefdsIconSymbol.squareAndPencil.rawValue)
        }
    }
    
    private func contextMenuRemove(transaction: TransactionViewData.Transaction) -> some View {
        Button {
            withAnimation {
                presenter.remove(transaction: transaction.id) {
                    presenter.alert = .init(error: $0)
                }
            }
        } label: {
            Label(presenter.string(.remove), systemImage: RefdsIconSymbol.trashFill.rawValue)
        }
    }
    
    private var buttonAddTransaction: some View {
        Button { presenter.isPresentedAddTransaction.toggle() } label: {
            RefdsIcon(
                symbol: .plusRectangleFill,
                color: .accentColor,
                size: 20,
                weight: .medium,
                renderingMode: .hierarchical
            )
        }
    }
    
    @available(iOS 16.0, *)
    private var sectionChartTransactions: some View {
        Chart {
            ForEach(presenter.viewData.chart, id: \.date) {
                buildAreaMarkTransactions($0)
            }
        }
        .chartLegend(position: .overlay, alignment: .top, spacing: -20)
        .chartYAxis { AxisMarks(position: .leading) }
        .frame(minHeight: 280)
        .padding()
        .padding(.top)
    }
    
    @available(iOS 16.0, *)
    func buildAreaMarkTransactions(_ data: TransactionViewData.Chart) -> some ChartContent {
        AreaMark(
            x: .value(presenter.string(.chartDate), data.date),
            y: .value(presenter.string(.chartValue), data.value)
        )
        .foregroundStyle(Gradient(colors: [.accentColor.opacity(0.5), .accentColor.opacity(0.25)]))
        .position(by: .value(presenter.string(.chartDate), data.date))
    }
}
