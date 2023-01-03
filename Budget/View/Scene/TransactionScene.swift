//
//  TransactionScene.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI

struct TransactionScene: View {
    @StateObject private var presenter: TransactionPresenter
    @State private var isPresentedAddTransaction = false
    private var category: CategoryEntity?
    
    init(category: CategoryEntity? = nil) {
        self.category = category
        _presenter = StateObject(wrappedValue: TransactionPresenter(category: category))
    }
    
    var body: some View {
        NavigationStack {
            list
                .navigationTitle(category == nil ? BudgetApp.TabItem.transaction.title : category!.name.capitalized)
                .navigationDestination(isPresented: $isPresentedAddTransaction, destination: { AddTransactionScene() })
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        HStack {
                            buttonAddTransaction
                            if presenter.isFilterPerDate { buttonCalendar }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if presenter.isFilterPerDate {
                            RefdsTag(presenter.date.asString(withDateFormat: "MMMM, yyyy"), color: .teal)
                        }
                    }
                }
                .searchable(text: $presenter.query, prompt: "Busque por transações")
                .onAppear { presenter.loadData() }
        }
        .tabItem {
            Image(systemName: "list.triangle")
            RefdsText(BudgetApp.TabItem.transaction.title, size: .normal)
        }
        .tag(BudgetApp.TabItem.transaction)
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
            RefdsTag(transaction.category.name, color: .randomColor)
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
    
    private var buttonCalendar: some View {
        Button {  } label: {
            ZStack {
                DatePicker("", selection: Binding(get: { presenter.date }, set: { presenter.date = $0; presenter.loadData() }), displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .frame(width: 20, height: 20)
                    .clipped()
                SwiftUIWrapper {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.accentColor)
                        .bold()
                }.allowsHitTesting(false)
            }
        }
    }
    
    private var buttonAddTransaction: some View {
        Button { isPresentedAddTransaction.toggle() } label: {
            Image(systemName: "plus.rectangle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.accentColor)
                .bold()
        }
    }
}

struct TransactionScene_Previews: PreviewProvider {
    static var previews: some View {
        TransactionScene()
    }
}
