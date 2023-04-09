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
            sectionTotal
            
            if #available(iOS 16.0, *),
               !presenter.chartData.compactMap({ $0.value }).isEmpty {
                CollapsedView(title: presenter.string(.chart)) {
                    sectionChartTransactions
                }
            }
            
            if !presenter.transactionsFiltred.isEmpty {
                sectionTransactions
            }
        }
        .listStyle(.insetGrouped)
        .budgetAlert($presenter.alert)
        .navigationTitle(presenter.category == nil ? presenter.string(.navigationTitle) : presenter.category!.name.capitalized)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { buttonAddTransaction } }
        .searchable(text: $presenter.query, prompt: presenter.string(.searchForTransactions))
        .onAppear { presenter.loadData() }
        .navigation(isPresented: $presenter.isPresentedAddTransaction) {
            presenter.router.configure(routes: .addTransaction(nil))
        }
        .navigation(isPresented: $presenter.isPresentedEditTransaction) {
            presenter.router.configure(routes: .addTransaction(presenter.transaction))
        }
    }
    
    private var sectionOptions: some View {
        CollapsedView(title: presenter.string(.options)) {
            Group {
                Toggle(isOn: $presenter.isFilterPerDate) {
                    RefdsText(presenter.string(.filterPerDate))
                }
                .toggleStyle(CheckBoxStyle())
                
                if presenter.isFilterPerDate {
                    CollapsedView(title: presenter.string(.period), description: presenter.selectedPeriod.value.capitalized) {
                        ForEach(PeriodTransaction.allCases, id: \.self) { period in
                            Button {
                                presenter.selectedPeriod = period
                            } label: {
                                HStack(spacing: 15) {
                                    IndicatorPointView(color: presenter.selectedPeriod == period ? .accentColor : .secondary)
                                    RefdsText(period.value.capitalized, color: .secondary)
                                }
                            }
                        }
                    }
                    
                    PeriodSelectionView(date: $presenter.date, dateFormat: .custom("dd MMMM, yyyy"))
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
                    presenter.totalAmount.currency,
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
        ForEach(presenter.transactionsFiltred, id: \.id) { transaction in
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
    
    private func rowTransactionTop(_ transaction: TransactionEntity) -> some View {
        HStack {
            RefdsTag(transaction.date.asString(withDateFormat: .custom("EEE HH:mm")), color: .secondary)
            RefdsText(transaction.date.asString(withDateFormat: .custom("dd MMMM, yyyy")))
            Spacer()
            RefdsTag(transaction.category?.name ?? "", color: transaction.category?.color ?? .accentColor)
        }
    }
    
    private func rowTransactionBottom(_ transaction: TransactionEntity) -> some View {
        HStack {
            RefdsText(transaction.description.isEmpty ? presenter.string(.noDescription) : transaction.description, color: .secondary)
            Spacer()
            RefdsText(transaction.amount.currency, family: .moderatMono, alignment: .trailing, lineLimit: 1)
        }
    }
    
    private func swipeRemove(transaction: TransactionEntity) -> some View {
        Button {
            withAnimation {
                presenter.remove(transaction: transaction) {
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
    
    private func swipeEdit(transaction: TransactionEntity) -> some View {
        Button {
            withAnimation {
                presenter.transaction = transaction
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
    
    private func contextMenuEdit(transaction: TransactionEntity) -> some View {
        Button {
            withAnimation {
                presenter.transaction = transaction
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    presenter.isPresentedEditTransaction.toggle()
                }
            }
        } label: {
            Label(presenter.string(.edit), systemImage: RefdsIconSymbol.squareAndPencil.rawValue)
        }
    }
    
    private func contextMenuRemove(transaction: TransactionEntity) -> some View {
        Button {
            withAnimation {
                presenter.remove(transaction: transaction) {
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
            ForEach(presenter.chartData, id: \.date) {
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
    func buildAreaMarkTransactions(_ data: (date: Date, value: Double)) -> some ChartContent {
        AreaMark(
            x: .value(presenter.string(.chartDate), data.date),
            y: .value(presenter.string(.chartValue), data.value)
        )
        .foregroundStyle(Gradient(colors: [.accentColor.opacity(0.5), .accentColor.opacity(0.25)]))
        .position(by: .value(presenter.string(.chartDate), data.date))
    }
}

