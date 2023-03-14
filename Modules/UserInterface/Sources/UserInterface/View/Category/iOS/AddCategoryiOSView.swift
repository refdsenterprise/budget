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
    }
    
    private var sectionName: some View {
        Section {
            rowName
            rowColor
        } header: {
            RefdsText(
                presenter.string(.sectionName),
                size: .extraSmall,
                color: .secondary
            )
        }
    }
    
    private var rowName: some View {
        HStack {
            RefdsText(presenter.string(.rowName))
            RefdsTextField(presenter.string(.placehoderRowName), text: $presenter.name, alignment: .trailing, textInputAutocapitalization: .characters)
        }
    }
    
    private var rowColor: some View {
        HStack {
            RefdsText(presenter.string(.rowColor))
            Spacer()
            ColorPicker(selection: $presenter.color, supportsOpacity: false) {}
        }
    }
    
    private var sectionBudget: some View {
        Section {
            rowBudget
            buttonAddBudget
        } header: {
            RefdsText(
                presenter.string(.sectionBudget),
                size: .extraSmall,
                color: .secondary
            )
        }
    }
    
    private var rowBudget: some View {
        Group {
            if !presenter.budgets.isEmpty {
                ForEach(presenter.budgets, id: \.self) { budget in
                    rowBudget(budget)
                        .contextMenu {
                            if let category = presenter.category {
                                contextMenuRemoveBudget(category: category, budget: budget)
                            }
                        }
                }
            } else {
                RefdsText(presenter.string(.noBudgetAdd))
            }
        }
    }
    
    private func rowBudget(_ budget: BudgetEntity) -> some View {
        HStack(spacing: 15) {
            RefdsText(budget.date.asString(withDateFormat: .custom("MMMM yyyy")).capitalized)
            Spacer()
            RefdsText(
                budget.amount.currency,
                size: .normal,
                color: .secondary,
                family: .moderatMono,
                lineLimit: 1
            )
        }
        .padding(.vertical, 4)
    }
    
    private func contextMenuRemoveBudget(category: CategoryEntity, budget: BudgetEntity) -> some View {
        Button {
            presenter.remove(budget: budget, on: category, onSuccess: nil, onError: {
                presenter.alert = .init(error: $0)
            })
        } label: {
            Label(
                presenter.string(.removeBudget),
                systemImage: RefdsIconSymbol.trashFill.rawValue
            )
        }
    }
    
    private var buttonSave: some View {
        Button {
            Application.shared.endEditing()
            presenter.save {
                dismiss()
            } onError: {
                presenter.alert = .init(error: $0)
            }
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
        NavigationLink(destination: presenter.router.configure(routes: .addBudget {
            presenter.add(budget: $0) {
                presenter.alert = .init(error: $0)
            }
        })) {
            RefdsText(
                presenter.string(.addBudget),
                size: .small,
                color: .accentColor,
                weight: .bold
            )
        }
    }
}
