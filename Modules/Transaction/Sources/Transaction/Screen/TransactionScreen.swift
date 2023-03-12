//
//  TransactionScreen.swift
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

public struct TransactionScreen: View {
    @StateObject private var presenter: TransactionPresenter
    @State private var isPresentedAddTransaction = false
    @State private var isPresentedExporting = false
    @State private var isPresentedEditTransaction = false
    @State private var showDatePicker = false
    @State private var showShareSheet = false
    @State private var transaction: TransactionEntity?
    private var category: CategoryEntity?
    @EnvironmentObject private var actionService: ActionService
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var appConfigurator: AppConfiguration
    
    let addCategoryScene: () -> any View
    
    public init(presenter: TransactionPresenter, category: CategoryEntity? = nil, date: Date? = nil, addCategoryScene: @escaping () -> any View) {
        self.category = category
        _presenter = StateObject(wrappedValue: presenter)
        self.addCategoryScene = addCategoryScene
    }
    
    public var body: some View {
        list
            .navigationTitle(category == nil ? "Transações" : category!.name.capitalized)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                        buttonAddTransaction
                        //buttonExport
                    }
                }
            }
            .searchable(text: $presenter.query, prompt: "Busque por transações")
            .onAppear {
                presenter.loadData()
                appConfigurator.themeColor = category?.color ?? .accentColor
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    switch scenePhase {
                    case .active: performActionIfNeeded()
                    default: break
                    }
                }
            }
            .onDisappear { appConfigurator.themeColor = .accentColor }
            .navigation(isPresented: $isPresentedAddTransaction) {
                presenter.router.configure(routes: .addTransaction(nil))
            }
            .navigation(isPresented: $isPresentedEditTransaction) {
                presenter.router.configure(routes: .addTransaction(transaction))
            }
        
    }
    
    private var list: some View {
        List {
            sectionOptions
            
            sectionTotal(presenter.getTotalAmount())
            if #available(iOS 16.0, *), let chartData = presenter.getChartData(), !chartData.compactMap({ $0.value }).isEmpty {
                CollapsedView(title: "Gráfico") {
                    sectionChartTransactions(chartData)
                }
            }
            if !presenter.getTransactionsFiltred().isEmpty {
                sectionTransactions
                Section {
                    csvRow
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    private func sectionTotal(_ total: Double) -> some View {
        Section {} header: {
            VStack(spacing: 10) {
                RefdsText("total das transações".uppercased(), size: .custom(12), color: .secondary)
                RefdsText(
                    total.formatted(.currency(code: "BRL")),
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
    
    private var selectionPeriodView: some View {
        SelectionTabView(
            values: PeriodTransaction.values,
            selected: $presenter.selectedPeriodString
        )
    }
    
    private var sectionOptions: some View {
        CollapsedView(title: "Opções") {
            Group {
                Toggle(isOn: Binding(get: { presenter.isFilterPerDate }, set: { presenter.isFilterPerDate = $0; presenter.loadData() })) { RefdsText("Filtrar por data") }
                    .toggleStyle(CheckBoxStyle())
                
                if presenter.isFilterPerDate {
                    CollapsedView(title: "Período", description: presenter.selectedPeriod.value.capitalized) {
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
                }
                
                if presenter.isFilterPerDate {
                    PeriodSelectionView(date: $presenter.date, dateFormat: .custom("dd MMMM, yyyy")) { _ in
                        presenter.loadData()
                    }
                }
            }
        }
    }
    
    private var csvRow: some View {
        Button {
            if presenter.csvStringWithTransactions() != nil {
                showShareSheet.toggle()
            }
        } label: {
            HStack(spacing: 15) {
                RefdsIcon(symbol: .squareAndArrowUp, color: .accentColor, size: 20, weight: .medium, renderingMode: .hierarchical)
                RefdsText("Exportar transações em CSV")
            }
        }
    }
    
    private var sectionTransactions: some View {
        ForEach(presenter.getTransactionsFiltred(), id: \.id) { transaction in
            Section {
                VStack {
                    rowTransaction1(transaction)
                    Divider()
                    rowTransaction2(transaction)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false, content: { swipeRemoveTransaction(transaction) })
                .swipeActions(edge: .leading, allowsFullSwipe: false, content: { swipeEditTransaction(transaction) })
            }
        }
    }
    
    private func rowTransaction1(_ transaction: TransactionEntity) -> some View {
        HStack {
            RefdsTag(transaction.date.asString(withDateFormat: .custom("EEE HH:mm")), color: .secondary)
            RefdsText(transaction.date.asString(withDateFormat: .custom("dd MMMM, yyyy")))
            Spacer()
            RefdsTag(transaction.category?.name ?? "", color: transaction.category?.color ?? .accentColor)
        }
    }
    
    private func rowTransaction2(_ transaction: TransactionEntity) -> some View {
        HStack {
            RefdsText(transaction.description.isEmpty ? "Sem descrição" : transaction.description, color: .secondary)
            Spacer()
            RefdsText(transaction.amount.formatted(.currency(code: "BRL")), family: .moderatMono, alignment: .trailing, lineLimit: 1)
        }
    }
    
    private func swipeRemoveTransaction(_ transaction: TransactionEntity) -> some View {
        Button { presenter.removeTransaction(transaction) } label: {
            Image(systemName: "trash.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
        }
        .tint(.pink)
    }
    
    private func swipeEditTransaction(_ transaction: TransactionEntity) -> some View {
        Button {
            self.transaction = transaction
            isPresentedEditTransaction.toggle()
        } label: {
            Image(systemName: "square.and.pencil")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
        }
        .tint(.orange)
    }
    
    private var buttonAddTransaction: some View {
        Button { isPresentedAddTransaction.toggle() } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 25)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.accentColor)
        }
    }
    
    private var buttonExport: some View {
        Button {
            Application.shared.endEditing()
            isPresentedExporting.toggle()
        } label: {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.secondary)
        }
    }
    
    private func performActionIfNeeded() {
        guard let action = actionService.action else { return }
        switch action {
        case .newTransaction: isPresentedAddTransaction.toggle()
        default: break
        }
        actionService.action = nil
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
            .frame(minHeight: 150)
            .padding()
            .padding(.top)
    }
    
    @available(iOS 16.0, *)
    func buildAreaMarkTransactions(_ data: (date: Date, value: Double)) -> some ChartContent {
        AreaMark(
            x: .value("date", data.date),
            y: .value("value", data.value)
        )
        .foregroundStyle(Gradient(colors: [.accentColor.opacity(0.5), .accentColor.opacity(0.25)]))
        .position(by: .value("date", data.date))
    }
}
