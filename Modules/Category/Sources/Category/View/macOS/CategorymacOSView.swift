//
//  CategorymacOSView.swift
//
//
//  Created by Rafael Santos on 10/03/23.
//

import SwiftUI
import RefdsUI
import Domain
import Presentation
import UserInterface
import Resource

struct CategorymacOSView<Presenter: CategoryPresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    private let transactionScene: ((CategoryEntity, Date) -> any View)?
    
    init(presenter: Presenter, transactionScene: ((CategoryEntity, Date) -> any View)? = nil) {
        self._presenter = StateObject(wrappedValue: presenter)
        self.transactionScene = transactionScene
    }
    
    var body: some View {
        list
            .budgetAlert($presenter.alert)
            .navigationTitle(Strings.Category.navigationTitle.value)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { buttonAddCategory } }
            .searchable(text: $presenter.query, prompt: Strings.Category.searchPlaceholder.value)
            .onAppear { presenter.loadData()  }
    }
    
    private var list: some View {
        List {
            CollapsedView(title: Strings.Category.sectionOptions.value) {
                options
            }
            if let previousDate = presenter.getDateFromLastCategoriesByCurrentDate() {
                sectionDuplicateCategories(previousDate: previousDate)
            }
            if !presenter.getCategoriesFiltred().isEmpty, let transactionScene = transactionScene {
                sectionCategories(transactionScene: transactionScene)
                sectionTotal(budget: presenter.totalBudget, actual: presenter.totalActual)
            }
        }
        .listStyle(.insetGrouped)
        .background(
            NavigationLink(destination: AddCategoryScreen(device: .iOS, presenter: AddCategoryPresenter.instance), isActive: $presenter.isPresentedAddCategory) {
                EmptyView()
            }.hidden()
        )
        .background(
            NavigationLink(destination: AddCategoryScreen(device: .iOS, presenter: AddCategoryPresenter(category: presenter.category)), isActive: $presenter.isPresentedEditCategory) {
                EmptyView()
            }.hidden()
        )
    }
    
    private var options: some View {
        Group {
            HStack {
                Toggle(isOn: Binding(get: { presenter.isFilterPerDate }, set: { presenter.isFilterPerDate = $0; presenter.loadData() })) { RefdsText(Strings.Category.sectionOptionsFilterPerDate.value) }
                    .toggleStyle(CheckBoxStyle())
            }
            if presenter.isFilterPerDate {
                PeriodSelectionView(date: $presenter.date, dateFormat: .custom("MMMM, yyyy")) { _ in
                    presenter.loadData()
                }
            }
        }
    }
    
    private func sectionDuplicateCategories(previousDate: Date) -> some View {
        Section {
            VStack(alignment: .center, spacing: 20) {
                RefdsText(Strings.Category.sectionDuplicateNotFound.value, size: .large, weight: .bold, alignment: .center)
                RefdsText(Strings.Category.sectionDuplicateSuggestion.value, color: .secondary, alignment: .center)
                Button {
                    presenter.duplicateCategories(from: previousDate)
                } label: {
                    RefdsText(Strings.Category.sectionDuplicateButton.value.uppercased(), size: .small, color: .accentColor, weight: .bold)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.accentColor.opacity(0.2))
                .cornerRadius(10)
            }
            .padding()
        }
    }
    
    private func sectionCategories(transactionScene: @escaping (CategoryEntity, Date) -> any View) -> some View {
        Section {
            ForEach(presenter.getCategoriesFiltred(), id: \.id) { category in
                NavigationLink(destination: {
                    AnyView(transactionScene(category, presenter.date))
                        .tint(category.color)
                }, label: {
                    rowCategory(category)
                })
                .contextMenu {
                    contextMenuEditCategory(category)
                    contextMenuRemoveCategory(category)
                }
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
                if let transactions = presenter.getTransactions(by: category),
                   let percent = presenter.getDifferencePercent(on: category, hasPlaces: true) {
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
            presenter.remove(category: category) {
                presenter.alert.present(error: $0)
            }
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
    
    private func contextMenuEditCategory(_ category: CategoryEntity) -> some View {
        Button {
            presenter.category = category
            presenter.isPresentedEditCategory.toggle()
        } label: {
            Label("Editar \(category.name.lowercased())", systemImage: RefdsIconSymbol.squareAndPencil.rawValue)
        }
    }
    
    private func contextMenuRemoveCategory(_ category: CategoryEntity) -> some View {
        Button {
            presenter.remove(category: category) {
                presenter.alert.present(error: $0)
            }
        } label: {
            Label("Remover \(category.name.lowercased())", systemImage: RefdsIconSymbol.trashFill.rawValue)
        }
    }
    
    private var buttonAddCategory: some View {
        Button { presenter.isPresentedAddCategory.toggle() } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 25)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.accentColor)
        }
    }
}

struct CategorymacOSView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                CategoryScreen(device: .macOS, presenter: CategoryPresenter.instance)
            }
            .previewDevice(PreviewDevice(rawValue: "iPad Air (5th generation)"))
        }
    }
}
