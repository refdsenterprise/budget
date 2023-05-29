//
//  CategoryiOSView.swift
//  
//
//  Created by Rafael Santos on 10/03/23.
//

import SwiftUI
import RefdsUI
import Domain
import Presentation
#if os(iOS)
struct CategoryiOSView<Presenter: CategoryPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        List {
            sectionOptions
            if presenter.categoryIsEmpty {
                sectionNonCategories
            } else if presenter.budgetIsEmpty {
                sectionNonBudgets
                if presenter.needShowModalPro { ProSection() }
            } else if !presenter.viewData.budgets.isEmpty {
                sectionCategories
                sectionTotal
                if presenter.needShowModalPro { ProSection() }
            }
            
        }
        .listStyle(.insetGrouped)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { buttonAddCategory } }
        .budgetAlert($presenter.alert)
        .navigationTitle(presenter.string(.navigationTitle))
        .searchable(text: $presenter.query, prompt: presenter.string(.searchPlaceholder))
        .onAppear { presenter.loadData() }
        .overlay(alignment: .center) { loading }
        .navigation(isPresented: $presenter.isPresentedAddCategory) {
            presenter.router.configure(routes: .addCategory(nil))
        }
        .navigation(isPresented: $presenter.isPresentedEditCategory) {
            presenter.router.configure(routes: .addCategory(presenter.category))
        }
        .navigation(isPresented: $presenter.isPresentedAddBudget) {
            presenter.router.configure(routes: .addBudget)
        }
    }
    
    private var loading: some View {
        Group {
            if presenter.showLoading {
                ProgressView()
            }
        }
    }
    
    private var sectionNonCategories: some View {
        Section {
            VStack(alignment: .center, spacing: 15) {
                RefdsText(presenter.string(.alertCreateCategoryTitle), size: .large, weight: .bold, alignment: .center)
                RefdsText(presenter.string(.alertCreateCategoryDescription), color: .secondary, alignment: .center)
                Button { presenter.isPresentedAddCategory.toggle() } label: {
                    RefdsText(presenter.string(.alertButton).uppercased(), size: .extraSmall, color: .white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .cornerRadius(8)
            }
            .padding()
        }
    }
    
    private var sectionNonBudgets: some View {
        Section {
            VStack(alignment: .center, spacing: 15) {
                RefdsText(presenter.string(.alertCreateBudgetTitle), size: .large, weight: .bold, alignment: .center)
                RefdsText(presenter.string(.alertCreateBudgetDescription), color: .secondary, alignment: .center)
                Button { presenter.isPresentedAddBudget.toggle() } label: {
                    RefdsText(presenter.string(.alertButton).uppercased(), size: .extraSmall, color: .white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .cornerRadius(8)
            }
            .padding()
        }
    }
    
    private var sectionOptions: some View {
        Group {
            if !presenter.isPro {
                HStack {
                    RefdsText(presenter.string(.sectionOptions))
                    Spacer()
                    ProTag()
                }
            } else {
                CollapsedView(title: presenter.string(.sectionOptions)) {
                    Group {
                        Toggle(isOn: $presenter.isFilterPerDate) {
                            RefdsText(presenter.string(.sectionOptionsFilterPerDate))
                        }
                        .tint(.accentColor)
                        
                        if presenter.isFilterPerDate {
                            PeriodSelectionView(date: $presenter.date, dateFormat: .custom("MMMM, yyyy"))
                        }
                    }
                }
            }
        }
    }
    
    private var sectionCategories: some View {
        Section {
            ForEach(presenter.viewData.budgets, id: \.id) { category in
                NavigationLink(destination: {
                    presenter.router.configure(routes: .transactions(category.id, presenter.date))
                }, label: {
                    rowCategory(category)
                })
                .contextMenu {
                    contextMenuEditCategory(category)
                    contextMenuRemoveCategory(category)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    swipeEditCategory(category)
                    swipeRemoveCategory(category)
                }
            }
            NavigationLink(destination: { presenter.router.configure(routes: .addBudget) }) {
                RefdsText("Adicionar Budget")
            }
        } header: {
            RefdsText(
                presenter.string(.mediumBudget),
                size: .extraSmall,
                color: .secondary
            )
        }
    }
    
    private var sectionTotal: some View {
        Section {} header: {
            VStack(spacing: 10) {
                RefdsText(
                    presenter.string(.currentValue).uppercased(),
                    size: .custom(12),
                    color: .secondary
                )
                RefdsText(
                    presenter.viewData.value.totalActual.currency,
                    size: .custom(40),
                    color: .primary,
                    weight: .bold,
                    alignment: .center,
                    lineLimit: 1
                )
                RefdsText(
                    presenter.viewData.value.totalBudget.currency,
                    size: .custom(20),
                    color: .accentColor,
                    weight: .bold
                )
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func rowCategory(_ category: CategoryViewData.Budget) -> some View {
        HStack(spacing: 10) {
            IndicatorPointView(color: category.color)
            VStack(spacing: 2) {
                HStack {
                    RefdsText(category.name.capitalized, weight: .bold)
                    Spacer()
                    RefdsText(
                        category.budget.currency,
                        lineLimit: 1
                    )
                }
                
                HStack {
                    RefdsText(presenter.string(.rowSpending(category.percent)), color: .secondary)
                    Spacer()
                    RefdsText(presenter.string(.rowTransactionsAmount(category.amountTransactions)), color: .secondary)
                }
            }
        }
    }
    
    private func swipeRemoveCategory(_ category: CategoryViewData.Budget) -> some View {
        Button {
            Task { await presenter.remove(category) }
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
    
    private func swipeEditCategory(_ category: CategoryViewData.Budget) -> some View {
        Button {
            withAnimation {
                presenter.category = category.id
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    presenter.isPresentedEditCategory.toggle()
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
    
    private func contextMenuEditCategory(_ category: CategoryViewData.Budget) -> some View {
        Button {
            withAnimation {
                presenter.category = category.id
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    presenter.isPresentedEditCategory.toggle()
                }
            }
        } label: {
            Label(presenter.string(.edit), systemImage: RefdsIconSymbol.squareAndPencil.rawValue)
        }
    }
    
    private func contextMenuRemoveCategory(_ category: CategoryViewData.Budget) -> some View {
        Button {
            Task { await presenter.remove(category) }
        } label: {
            Label(presenter.string(.remove), systemImage: RefdsIconSymbol.trashFill.rawValue)
        }
    }
    
    private var buttonAddCategory: some View {
        Button { presenter.isPresentedAddCategory.toggle() } label: {
            RefdsIcon(
                symbol: .plusRectangleFill,
                color: .accentColor,
                size: 20,
                weight: .medium,
                renderingMode: .hierarchical
            )
        }
    }
}
#endif
