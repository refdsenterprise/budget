//
//  TransactionmacOSView.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import SwiftUI
import RefdsUI
import Charts
import Domain
import Presentation

struct TransactionmacOSView<Presenter: TransactionPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        MacUIView(sections: [
            .init(maxAmount: 2, content: {
                Group {
                    sectionTotal(presenter.totalAmount)
                    sectionOptions
                }
            }),
            .init(maxAmount: 1, content: {
                Group {
                    if #available(iOS 16.0, *),
                       let chartData = presenter.chartData,
                       !chartData.compactMap({ $0.value }).isEmpty {
                        CollapsedView(title: presenter.string(.chart)) {
                            sectionChartTransactions(chartData)
                        }
                        .padding(.horizontal)
                    }
                }
            }),
            .init(maxAmount: nil, content: {
                Group {
                    if let transactions = presenter.transactionsFiltred, !transactions.isEmpty {
                        sectionTransactions(transactions)
                    }
                }
            })
        ])
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
        SectionGroup {
            CollapsedView(title: presenter.string(.options)) {
                Group {
                    Toggle(isOn: $presenter.isFilterPerDate) {
                        RefdsText(presenter.string(.filterPerDate))
                    }
                    .toggleStyle(CheckBoxStyle())
                    
                    if presenter.isFilterPerDate {
                        CollapsedView(title: presenter.string(.period), description: presenter.selectedPeriod.value.capitalized) {
                            VStack(alignment: .leading) {
                                ForEach(PeriodTransaction.allCases.indices, id: \.self) { index in
                                    let period = PeriodTransaction.allCases[index]
                                    Button {
                                        presenter.selectedPeriod = period
                                    } label: {
                                        HStack(spacing: 15) {
                                            IndicatorPointView(color: presenter.selectedPeriod == period ? .accentColor : .secondary)
                                            RefdsText(period.value.capitalized, color: .secondary)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                    if index < PeriodTransaction.allCases.count - 1 { Divider() }
                                }
                            }
                        }
                        
                        PeriodSelectionView(date: $presenter.date, dateFormat: .custom("dd MMMM, yyyy")) { _ in
                            presenter.loadData()
                        }
                    }
                }
            }
        }
    }
    
    private func sectionTotal(_ total: Double) -> some View {
        VStack(spacing: 10) {
            RefdsText(
                presenter.string(.totalTransactions).uppercased(),
                size: .custom(12),
                color: .secondary
            )
            RefdsText(
                total.currency,
                size: .custom(40),
                color: .primary,
                weight: .bold,
                family: .moderatMono,
                alignment: .center,
                lineLimit: 1
            )
        }
        .frame(maxWidth: .infinity)
    }
    
    private func sectionTransactions(_ transactions: [TransactionEntity]) -> some View {
        ForEach(transactions, id: \.id) { transaction in
            Button {} label: {
                VStack {
                    rowTransactionTop(transaction)
                    Divider()
                    rowTransactionBottom(transaction)
                    Spacer()
                }
            }
            .frame(minHeight: 90, maxHeight: 90)
            .padding()
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
    private func sectionChartTransactions(_ chartData: [(date: Date, value: Double)]) -> some View {
        Chart {
            ForEach(chartData, id: \.date) {
                buildAreaMarkTransactions($0)
            }
        }
        .chartLegend(position: .overlay, alignment: .top, spacing: -20)
        .chartYAxis { AxisMarks(position: .leading) }
        .frame(minHeight: 300)
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

