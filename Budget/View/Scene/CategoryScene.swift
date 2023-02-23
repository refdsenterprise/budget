//
//  CategoryScene.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI

struct CategoryScene: View {
    @StateObject private var presenter: CategoryPresenter = .instance
    @State private var isPresentedAddCategory = false
    @State private var isPresentedEditCategory = false
    @State private var isPresentedExporting = false
    @State private var showDatePicker = false
    @State private var isPresentedAlert: (Bool, BudgetError) = (false, .notFoundCategory)
    @State private var category: CategoryEntity?
    @EnvironmentObject private var actionService: ActionService
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        list
            .navigationTitle(BudgetApp.TabItem.category.title)
        #if os(iOS)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                        buttonAddCategory
                        //buttonExport
                    }
                }
            }
        #endif
            .searchable(text: $presenter.query, prompt: "Busque por categoria")
            .onAppear {
                presenter.loadData()
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    switch scenePhase {
                    case .active: performActionIfNeeded()
                    default: break
                    }
                }
            }
            .fileExporter(isPresented: $isPresentedExporting, document: presenter.document, contentType: .json, defaultFilename: "categories.json") { result in
                if case .success = result { print("success to export")
                } else { print("failed to export") }
            }
            .alertBudgetError(isPresented: $isPresentedAlert)
    }
    
    private var list: some View {
        List {
            CollapsedView(title: "Opções") {
                options
            }
            if let previousDate = presenter.getDateFromLastCategoriesByCurrentDate() {
                sectionDuplicateCategories(previousDate: previousDate)
            }
            if !presenter.getCategoriesFiltred().isEmpty {
                sectionCategories
                sectionTotal(budget: presenter.getTotalBudget(), actual: presenter.getTotalActual())
            }
        }
        .listStyle(.insetGrouped)
        .background(
            NavigationLink(destination: AddCategoryScene(), isActive: $isPresentedAddCategory) {
                EmptyView()
            }.hidden()
        )
        .background(
            NavigationLink(destination: AddCategoryScene(category: category), isActive: $isPresentedEditCategory) {
                EmptyView()
            }.hidden()
        )
    }
    
    private var options: some View {
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
                        RefdsTag(presenter.date.asString(withDateFormat: "MMMM, yyyy"), color: .accentColor)
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
    
    private func sectionDuplicateCategories(previousDate: Date) -> some View {
        Section {
            VStack(alignment: .center, spacing: 20) {
                RefdsText("Nenhuma categoria encontrada", size: .large, weight: .bold, alignment: .center)
                RefdsText("Podemos duplicar os budgets do mês anterior mantendo a mesma categoria", color: .secondary, alignment: .center)
                Button {
                    presenter.duplicateCategories(from: previousDate)
                } label: {
                    RefdsText("DUPLICAR", size: .small, color: .accentColor, weight: .bold)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.accentColor.opacity(0.2))
                .cornerRadius(10)
            }
            .padding()
        }
    }
    
    private var sectionCategories: some View {
        Section {
            ForEach(presenter.getCategoriesFiltred(), id: \.id) { category in
                NavigationLink(destination: { TransactionScene(category: category, date: presenter.date).tint(category.color) }, label: {
                    rowCategory(category)
                })
                .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                    Button(action: {
                        self.category = category
                        isPresentedEditCategory.toggle()
                    }, label: { swipeEditCategory(category) })
                        .tint(.orange)
                })
            }
        } header: {
            if !presenter.getCategoriesFiltred().isEmpty {
                RefdsText("budget\(presenter.isFilterPerDate ? "" : " médio")", size: .extraSmall, color: .secondary)
            }
        }
    }
    
    private func sectionTotal(budget: Double, actual: Double) -> some View {
        Section {} header: {
            VStack(spacing: 10) {
                RefdsText("valor atual".uppercased(), size: .custom(12), color: .secondary)
                RefdsText(
                    actual.formatted(.currency(code: "BRL")),
                    size: .custom(40),
                    color: .primary,
                    weight: .bold,
                    family: .moderatMono,
                    alignment: .center,
                    lineLimit: 1
                )
                RefdsText(budget.formatted(.currency(code: "BRL")), size: .custom(20), color: .accentColor, weight: .bold, family: .moderatMono)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func rowCategory(_ category: CategoryEntity) -> some View {
        HStack(spacing: 10) {
            IndicatorPointView(color: category.color)
            VStack(spacing: 2) {
                HStack {
                    RefdsText(category.name.capitalized, weight: .bold)
                    Spacer()
                    if let budget = presenter.getBudget(by: category) {
                        RefdsText(
                            budget.amount.formatted(.currency(code: "BRL")),
                            family: .moderatMono,
                            lineLimit: 1
                        )
                    }
                }
                if let transactions = presenter.getTransactions(by: category), let actual = presenter.getActualTransaction(by: category), let percent = presenter.getDifferencePercent(budget: presenter.getBudget(by: category)?.amount ?? 1, actual: actual, hasPlaces: true) {
                    HStack {
                        RefdsText("\(percent) gasto", color: .secondary)
                        Spacer()
                        RefdsText("\(transactions.count) transações", color: .secondary)
                    }
                }
            }
        }
    }
    
    private func swipeRemoveCategory(_ category: CategoryEntity) -> some View {
        Button {
            do { try presenter.removeCategory(category) }
            catch { isPresentedAlert = (true, error as! BudgetError) }
        } label: {
            Image(systemName: "trash.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
        }
        .tint(.pink)
    }
    
    private func swipeEditCategory(_ category: CategoryEntity) -> some View {
        Button { } label: {
            Image(systemName: "square.and.pencil")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
        }
    }
    
    private var buttonAddCategory: some View {
        Button { isPresentedAddCategory.toggle() } label: {
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
        case .newCategory: isPresentedAddCategory.toggle()
        default: break
        }
        actionService.action = nil
    }
}

struct CategoryScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryScene()
        }
    }
}
