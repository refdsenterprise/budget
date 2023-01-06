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
    @State private var isPresentedExporting: Bool = false
    @State private var category: CategoryEntity?
    @EnvironmentObject private var actionService: ActionService
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        list
            .navigationTitle(BudgetApp.TabItem.category.title)
            .navigationDestination(isPresented: $isPresentedAddCategory, destination: { AddCategoryScene() })
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                        buttonAddCategory
                        if presenter.isFilterPerDate { buttonCalendar }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    buttonExport
                    if presenter.isFilterPerDate {
                        RefdsTag(presenter.date.asString(withDateFormat: "MMMM, yyyy"), color: .teal)
                    }
                }
            }
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
    }
    
    private var list: some View {
        List {
            sectionOptions
            if let previousDate = presenter.getDateFromLastCategoriesByCurrentDate() {
                sectionDuplicateCategories(previousDate: previousDate)
            }
            if !presenter.getCategoriesFiltred().isEmpty {
                sectionCategories
                if presenter.isFilterPerDate {
                    sectionTotalBudget(presenter.getTotalBudget())
                    sectionActualCategories
                    sectionTotalBudget(presenter.getTotalActual(), isActual: true)
                }
            }
        }
        .listStyle(.insetGrouped)
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
                NavigationLink(destination: { TransactionScene(category: category, date: presenter.date) }, label: {
                    rowCategory(category)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false, content: { swipeRemoveCategory(category) })
                        .swipeActions(edge: .trailing, allowsFullSwipe: false, content: {
                            NavigationLink(destination: { AddCategoryScene(category: category) }, label: { swipeEditCategory(category) })
                                .tint(.orange)
                        })
                })
            }
        } header: {
            if !presenter.getCategoriesFiltred().isEmpty {
                RefdsText("budget\(presenter.isFilterPerDate ? "" : " médio")", size: .extraSmall, color: .secondary)
            }
        }
    }
    
    private func sectionTotalBudget(_ budget: Double, isActual: Bool = false) -> some View {
        Section {} header: {
            VStack(spacing: 10) {
                RefdsText("total \(isActual ? "atual" : "budget")".uppercased(), size: .custom(12), color: .secondary)
                RefdsText(
                    budget.formatted(.currency(code: "BRL")),
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
    
    private var sectionActualCategories: some View {
        Section {
            ForEach(presenter.getCategoriesFiltred(), id: \.id) { category in
                rowActualCategory(category)
            }
        } header: {
            if !presenter.getCategoriesFiltred().isEmpty {
                RefdsText("atual", size: .extraSmall, color: .secondary)
            }
        }
    }
    
    private func rowCategory(_ category: CategoryEntity) -> some View {
        HStack {
            RefdsText(category.name.capitalized)
            Spacer()
            if let budget = presenter.getBudget(by: category) {
                RefdsText(
                    budget.amount.formatted(.currency(code: "BRL")),
                    color: .secondary,
                    weight: .bold,
                    family: .moderatMono,
                    lineLimit: 1
                )
            }
        }
    }
    
    private func rowActualCategory(_ category: CategoryEntity) -> some View {
        HStack {
            if let actual = presenter.getActualTransaction(by: category),
               let budget = presenter.getBudget(by: category)?.amount,
               let diffencePercent = presenter.getDifferencePercent(budget: budget, actual: actual) {
                RefdsTag(diffencePercent, size: .custom(12), color: category.color)
            }
            
            RefdsText(category.name.capitalized)
            Spacer()
            if let actual = presenter.getActualTransaction(by: category),
               let budget = presenter.getBudget(by: category)?.amount {
                RefdsText(
                    actual.formatted(.currency(code: "BRL")),
                    color: budget - actual > 0 ? .accentColor : budget - actual == 0 ? .secondary : .pink, weight: .bold,
                    family: .moderatMono,
                    lineLimit: 1
                )
            }
        }
    }
    
    private func swipeRemoveCategory(_ category: CategoryEntity) -> some View {
        Button { presenter.removeCategory(category) } label: {
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
    
    private var buttonAddCategory: some View {
        Button { isPresentedAddCategory.toggle() } label: {
            Image(systemName: "plus.rectangle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.accentColor)
                .bold()
        }
    }
    
    private var buttonExport: some View {
        Button {
            UIApplication.shared.endEditing()
            isPresentedExporting.toggle()
        } label: {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.secondary)
                .bold()
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
        CategoryScene()
    }
}

struct SwiftUIWrapper<T: View>: UIViewControllerRepresentable {
    let content: () -> T
    func makeUIViewController(context: Context) -> UIHostingController<T> {
        UIHostingController(rootView: content())
    }
    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {}
}
