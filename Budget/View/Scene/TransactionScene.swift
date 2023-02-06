//
//  TransactionScene.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI
import Charts

struct TransactionScene: View {
    @StateObject private var presenter: TransactionPresenter
    @State private var isPresentedAddTransaction = false
    @State private var isPresentedExporting: Bool = false
    private var category: CategoryEntity?
    @EnvironmentObject private var actionService: ActionService
    @Environment(\.scenePhase) private var scenePhase
    
    init(category: CategoryEntity? = nil, date: Date? = nil) {
        self.category = category
        _presenter = StateObject(wrappedValue: TransactionPresenter(category: category, date: date))
    }
    
    var body: some View {
        list
            .navigationTitle(category == nil ? BudgetApp.TabItem.transaction.title : category!.name.capitalized)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack { buttonAddTransaction }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    buttonExport
                    if presenter.isFilterPerDate {
                        RefdsTag(presenter.date.asString(withDateFormat: "dd MMMM, yyyy"), color: .teal)
                    }
                }
            }
            .searchable(text: $presenter.query, prompt: "Busque por transações")
            .onAppear {
                presenter.loadData()
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    switch scenePhase {
                    case .active: performActionIfNeeded()
                    default: break
                    }
                }
            }
            .fileExporter(isPresented: $isPresentedExporting, document: presenter.document, contentType: .json, defaultFilename: "trasactions.json") { result in
                if case .success = result { print("success to export")
                } else { print("failed to export") }
            }
    }
    
    private var list: some View {
        List {
            sectionOptions
            sectionTotal(presenter.getTotalAmount())
            if !presenter.getTransactionsFiltred().isEmpty {
                sectionTransactions
            }
        }
        .listStyle(.insetGrouped)
        .background(
            NavigationLink(destination: AddTransactionScene(), isActive: $isPresentedAddTransaction) {
                EmptyView()
            }.hidden()
        )
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
    
    private var sectionTransactions: some View {
        ForEach(presenter.getTransactionsFiltred(), id: \.id) { transaction in
            Section {
                VStack {
                    rowTransaction1(transaction)
                    Divider()
                    rowTransaction2(transaction)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false, content: { swipeRemoveTransaction(transaction) })
            }
        }
    }
    
    private func rowTransaction1(_ transaction: TransactionEntity) -> some View {
        HStack {
            RefdsText(transaction.date.asString(withDateFormat: "dd MMMM, yyyy"))
            Spacer()
            RefdsTag(transaction.category?.name ?? "", color: transaction.category?.color ?? .accentColor)
        }
    }
    
    private func rowTransaction2(_ transaction: TransactionEntity) -> some View {
        HStack {
            RefdsText(transaction.description.isEmpty ? "Sem descrição" : transaction.description, color: .secondary)
            Spacer()
            RefdsText(transaction.amount.formatted(.currency(code: "BRL")), color: .accentColor, weight: .bold, family: .moderatMono, alignment: .trailing, lineLimit: 1)
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
        Button { } label: {
            Image(systemName: "square.and.pencil")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
        }
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
}

struct TransactionScene_Previews: PreviewProvider {
    static var previews: some View {
        TransactionScene()
    }
}
