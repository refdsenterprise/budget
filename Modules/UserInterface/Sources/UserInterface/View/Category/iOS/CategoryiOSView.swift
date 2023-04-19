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

struct CategoryiOSView<Presenter: CategoryPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        List {
            sectionOptions
            
            if !presenter.viewData.budgets.isEmpty {
                sectionCategories
                sectionTotal
            }
        }
        .listStyle(.insetGrouped)
        .budgetAlert($presenter.alert)
        .navigationTitle(presenter.string(.navigationTitle))
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { buttonAddCategory } }
        .searchable(text: $presenter.query, prompt: presenter.string(.searchPlaceholder))
        .onAppear { presenter.loadData()  }
        .navigation(isPresented: $presenter.isPresentedAddCategory) {
            presenter.router.configure(routes: .addCategory(nil))
        }
        .navigation(isPresented: $presenter.isPresentedEditCategory) {
            presenter.router.configure(routes: .addCategory(presenter.category))
        }
    }
    
    private var sectionOptions: some View {
        CollapsedView(title: presenter.string(.sectionOptions)) {
            Group {
                Toggle(isOn: $presenter.isFilterPerDate) {
                    RefdsText(presenter.string(.sectionOptionsFilterPerDate))
                }
                .toggleStyle(CheckBoxStyle())
                
                if presenter.isFilterPerDate {
                    PeriodSelectionView(date: $presenter.date, dateFormat: .custom("MMMM, yyyy"))
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
                    family: .moderatMono,
                    alignment: .center,
                    lineLimit: 1
                )
                RefdsText(
                    presenter.viewData.value.totalBudget.currency,
                    size: .custom(20),
                    color: .accentColor,
                    weight: .bold,
                    family: .moderatMono
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
                        family: .moderatMono,
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
