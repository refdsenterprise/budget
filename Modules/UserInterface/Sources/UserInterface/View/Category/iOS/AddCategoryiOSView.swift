//
//  AddCategoryiOSView.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI
import Domain
import Presentation
#if os(iOS)
struct AddCategoryiOSView<Presenter: AddCategoryPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            sectionName
            sectionBudget
        }
        .budgetAlert($presenter.alert)
        .navigationTitle(presenter.string(.navigationTitle))
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { buttonSave } }
        .gesture(DragGesture().onChanged({ _ in Application.shared.endEditing() }))
        .task { await presenter.start(id: presenter.id) }
        .navigation(isPresented: $presenter.isPresentedEditBudget) {
            presenter.router.configure(routes: .addBudget({ budget in
                Task { await presenter.add(budget: budget) }
            }, category: presenter.viewData.id, budget: presenter.budget))
        }
    }
    
    private var sectionName: some View {
        Section {
            rowName
            rowColor
        } header: {
            RefdsText(
                presenter.string(.headerCategory),
                size: .extraSmall,
                color: .secondary
            )
        }
    }
    
    private var rowName: some View {
        HStack {
            RefdsText(presenter.string(.labelName))
            RefdsTextField(
                presenter.string(.labelPlaceholderName),
                text: $presenter.viewData.name,
                alignment: .trailing,
                textInputAutocapitalization: .characters
            )
        }
    }
    
    private var rowColor: some View {
        HStack {
            RefdsText(presenter.string(.labelColor))
            Spacer()
            ColorPicker(
                selection: $presenter.viewData.color,
                supportsOpacity: false
            ) {}
        }
    }
    
    private var sectionBudget: some View {
        Section {
            rowBudget
            buttonAddBudget
        } header: {
            RefdsText(
                presenter.string(.headerBudgets),
                size: .extraSmall,
                color: .secondary
            )
        }
    }
    
    private var rowBudget: some View {
        Group {
            if !presenter.viewData.budgets.isEmpty {
                ForEach(presenter.viewData.budgets, id: \.id) { budget in
                    rowBudget(budget)
                        .contextMenu {
                            contextMenuRemoveBudget(
                                category: presenter.viewData,
                                budget: budget
                            )
                            contextMenuEditBudget(
                                category: presenter.viewData,
                                budget: budget
                            )
                        }
                }
            } else { RefdsText(presenter.string(.noBudgetAdded)) }
        }
    }
    
    private func rowBudget(_ budget: AddBudgetViewData) -> some View {
        HStack(spacing: 15) {
            RefdsText(budget.date.asString(withDateFormat: .custom("MMMM yyyy")).capitalized)
            Spacer()
            RefdsText(
                budget.amount.currency,
                size: .normal,
                color: .secondary,
                lineLimit: 1
            )
        }
        .padding(.vertical, 4)
    }
    
    private func contextMenuRemoveBudget(category: AddCategoryViewData, budget: AddBudgetViewData) -> some View {
        Button {
            Task { await presenter.remove(budget: budget, on: category)  }
        } label: {
            Label(
                presenter.string(.buttonRemoveBudget),
                systemImage: RefdsIconSymbol.trashFill.rawValue
            )
        }
    }
    
    private func contextMenuEditBudget(category: AddCategoryViewData, budget: AddBudgetViewData) -> some View {
        Button {
            presenter.budget = budget.id
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                presenter.isPresentedEditBudget.toggle()
            }
        } label: {
            Label(
                presenter.string(.buttonEditBudget),
                systemImage: RefdsIconSymbol.squareAndPencil.rawValue
            )
        }
    }
    
    private var buttonSave: some View {
        Button {
            Application.shared.endEditing()
            presenter.save { dismiss() }
        } label: {
            RefdsIcon(
                symbol: .checkmarkRectangleFill,
                color: presenter.buttonForegroundColor,
                size: 20,
                weight: .medium,
                renderingMode: .hierarchical
            )
        }
    }
    
    private var buttonAddBudget: some View {
        NavigationLink(destination: presenter.router.configure(routes: .addBudget({ budget in
            Task { await presenter.add(budget: budget) }
        }, category: presenter.viewData.id, budget: nil))) {
            RefdsText(
                presenter.string(.buttonAddBudget),
                size: .small,
                color: .accentColor,
                weight: .bold
            )
        }
    }
}
#endif
