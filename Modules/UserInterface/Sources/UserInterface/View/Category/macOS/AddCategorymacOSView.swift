//
//  AddCategorymacOSView.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI
import Domain
import Presentation

struct AddCategorymacOSView<Presenter: AddCategoryPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        RefdsList { proxy in
            RefdsSection(proxy: proxy, maxColumns: 2) {
                sectionForm
                sectionBudget
            }
        }
        .budgetAlert($presenter.alert)
        .navigationTitle(presenter.string(.navigationTitle))
        .gesture(DragGesture().onChanged({ _ in Application.shared.endEditing() }))
        .task { await presenter.start(id: presenter.id) }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .navigation(isPresented: $presenter.isPresentedEditBudget) {
            presenter.router.configure(routes: .addBudget({ budget in
                Task { await presenter.add(budget: budget) }
            }, category: presenter.viewData.id, budget: presenter.budget))
        }
    }
    
    private var sectionForm: some View {
        RefdsRow {
            VStack(spacing: 20) {
                Spacer(minLength: 0)
                RefdsTextField(
                    presenter.string(.labelPlaceholderName),
                    text: $presenter.viewData.name,
                    style: .largeTitle,
                    weight: .bold,
                    alignment: .center,
                    minimumScaleFactor: 0.4,
                    lineLimit: 1
                )
                Spacer(minLength: 0)
                ColorSelection(color: $presenter.viewData.color)
                Spacer(minLength: 0)
                RefdsButton {
                    presenter.save { dismiss() }
                } label: {
                    HStack {
                        Spacer()
                        RefdsText(presenter.id == nil ? presenter.string(.buttonCreate) : presenter.string(.buttonSave), color: presenter.buttonForegroundColor)
                        Spacer()
                    }
                }
                .disabled(!presenter.canAddNewCategory)
                .refdsCard()
            }
        }
    }
    
    private var sectionBudget: some View {
        VStack {
            rowBudget
            Spacer(minLength: 0)
            RefdsRow {
                HStack(spacing: 15) {
                    RefdsIcon(symbol: .plusSquareFill, size: 20)
                    RefdsText(presenter.string(.buttonAddBudget))
                }
            } destination: {
                presenter.router.configure(routes: .addBudget({ budget in
                    Task { await presenter.add(budget: budget) }
                }, category: presenter.viewData.id, budget: nil))
            }
        }
    }
    
    private var rowBudget: some View {
        Group {
            if !presenter.viewData.budgets.isEmpty {
                ForEach(presenter.viewData.budgets, id: \.id) { budget in
                    rowBudget(budget, from: presenter.viewData)
                }
            } else { RefdsText(presenter.string(.noBudgetAdded)).padding(.vertical, 10) }
        }
    }
    
    private func rowBudget(_ budget: AddBudgetViewData, from category: AddCategoryViewData) -> some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading) {
                RefdsText(
                    budget.amount.currency,
                    style: .body,
                    weight: .bold,
                    lineLimit: 1
                )
                RefdsText(
                    budget.date.asString(withDateFormat: .custom("MMMM yyyy")).capitalized,
                    color: .secondary
                )
            }
            Spacer()
            Menu {
                editBudget(category: category, budget: budget)
                removeBudget(category: category, budget: budget)
            } label: {
                RefdsIcon(
                    symbol: .ellipsisCircleFill,
                    color: .secondary,
                    renderingMode: .hierarchical
                )
            }
            .frame(width: 50)
        }
        .padding(.vertical, 4)
    }
    
    private func removeBudget(category: AddCategoryViewData, budget: AddBudgetViewData) -> some View {
        Button {
            Task { await presenter.remove(budget: budget, on: category)  }
        } label: {
            Label(
                presenter.string(.buttonRemoveBudget),
                systemImage: RefdsIconSymbol.trashFill.rawValue
            )
        }
    }
    
    private func editBudget(category: AddCategoryViewData, budget: AddBudgetViewData) -> some View {
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
}
