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

struct CategorymacOSView<Presenter: CategoryPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    @State private var isPresentedTransactions: Bool = false
    
    var body: some View {
        MacUIView(sections: sections)
            .budgetAlert($presenter.alert)
            .navigationTitle(presenter.string(.navigationTitle))
            .toolbar { ToolbarItem { buttonAddCategory } }
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
    
    private var sections: [MacUISection] {
        presenter.showLoading ? [] : [
            .init(maxAmount: 2, content: {
                Group {
                    sectionTotal
                    VStack {
                        sectionOptions
                        if !presenter.categoryIsEmpty, !presenter.budgetIsEmpty {
                            sectionAddBudget
                        }
                    }
                }
            }),
            .init(content: {
                Group {
                    if !presenter.categoryIsEmpty, !presenter.budgetIsEmpty {
                        sectionCategories
                    }
                }
            }),
            .init(maxAmount: nil, content: {
                Group {
                    if presenter.needShowModalPro {
                        ProSection()
                    }
                    
                    if presenter.categoryIsEmpty {
                        sectionNonCategories
                    } else if presenter.budgetIsEmpty {
                        sectionNonBudgets
                    }
                }
            })
        ]
    }
    
    private var sectionTotal: some View {
        VStack(spacing: 10) {
            RefdsText(
                presenter.string(.currentValue).uppercased(),
                style: .caption1,
                color: .secondary
            )
            RefdsText(
                presenter.viewData.value.totalActual.currency,
                style: .superTitle,
                color: .primary,
                weight: .bold,
                alignment: .center,
                lineLimit: 1
            )
            .frame(maxWidth: .infinity)
            RefdsText(
                presenter.viewData.value.totalBudget.currency,
                style: .title3,
                color: .accentColor,
                weight: .bold
            )
        }
        .frame(maxWidth: .infinity)
    }
    
    private var sectionOptions: some View {
        SectionGroup {
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
                            HStack {
                                RefdsToggle(isOn: $presenter.isFilterPerDate) {
                                    RefdsText(presenter.string(.sectionOptionsFilterPerDate))
                                }
                                .tint(.accentColor)
                                Spacer()
                            }
                            
                            if presenter.isFilterPerDate {
                                PeriodSelectionView(date: $presenter.date, dateFormat: .custom("MMMM, yyyy"))
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var sectionAddBudget: some View {
        SectionGroup {
            RefdsButton { presenter.isPresentedAddBudget.toggle() } label: {
                HStack {
                    RefdsText(presenter.string(.buttonAddBudget))
                    Spacer()
                }
            }
        }
    }
    
    private var sectionCategories: some View {
        ForEach(presenter.viewData.budgets, id: \.id) { category in
            GroupBox {
                CategoryCardView(category: category, placeHolderPercent: presenter.string(.rowSpending(category.percent)), placeHolderAmountTransactions: presenter.string(.rowTransactionsAmount(category.amountTransactions)))
            }
            .onTapGesture { isPresentedTransactions.toggle() }
            .padding(.all, 10)
            .listGroupBoxStyle(isButton: true)
            .navigation(isPresented: $isPresentedTransactions, destination: { presenter.router.configure(routes: .transactions(category.id, presenter.date)) })
            .contextMenu {
                contextMenuEditCategory(category)
                contextMenuRemoveCategory(category)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                swipeEditCategory(category)
                swipeRemoveCategory(category)
            }
        }
    }
    
    private var sectionNonCategories: some View {
        SectionGroup {
            VStack(alignment: .center, spacing: 15) {
                RefdsText(presenter.string(.alertCreateCategoryTitle), style: .body, weight: .bold, alignment: .center)
                RefdsText(presenter.string(.alertCreateCategoryDescription), color: .secondary, alignment: .center)
                Button { presenter.isPresentedAddCategory.toggle() } label: {
                    RefdsText(presenter.string(.alertButton).uppercased(), style: .caption1, color: .white)
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
        SectionGroup {
            VStack(alignment: .center, spacing: 15) {
                RefdsText(presenter.string(.alertCreateBudgetTitle), style: .body, weight: .bold, alignment: .center)
                RefdsText(presenter.string(.alertCreateBudgetDescription), color: .secondary, alignment: .center)
                Button { presenter.isPresentedAddBudget.toggle() } label: {
                    RefdsText(presenter.string(.alertButton).uppercased(), style: .caption1, color: .white)
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
