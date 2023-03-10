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
import UserInterface
import Resource

struct AddCategorymacOSView<Presenter: AddCategoryPresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    @Environment(\.dismiss) var dismiss
    
    init(presenter: Presenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    var body: some View {
        MacUIView(maxAmount: 2) {
            Group {
                sectionName
                sectionBudget
            }
        }
        .budgetAlert($presenter.alert)
        .navigationTitle(presenter.string(.navigationTitle))
        .gesture(DragGesture().onChanged({ _ in Application.shared.endEditing() }))
    }
    
    private var sectionName: some View {
        VStack {
            SectionGroup(headerTitle: presenter.string(.sectionName)) {
                VStack {
                    rowName
                    Divider()
                    rowColor
                }
            }
            buttonSave
            Spacer()
        }
    }
    
    private var rowName: some View {
        HStack {
            RefdsText(presenter.string(.rowName))
            RefdsTextField(
                presenter.string(.placehoderRowName),
                text: $presenter.name,
                alignment: .trailing,
                textInputAutocapitalization: .characters
            )
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
        VStack {
            SectionGroup(headerTitle: presenter.string(.sectionBudget)) {
                rowBudget
            }
            buttonAddBudget
            Spacer()
        }
    }
    
    private var rowBudget: some View {
        VStack {
            if !presenter.budgets.isEmpty {
                ForEach(presenter.budgets.indices, id: \.self) { index in
                    let budget = presenter.budgets[index]
                    rowBudget(budget)
                        .contextMenu {
                            if let category = presenter.category {
                                contextMenuRemoveBudget(category: category, budget: budget)
                            }
                        }
                    if index < presenter.budgets.count - 1 { Divider() }
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
                budget.amount.formatted(.currency(code: presenter.string(.currency))),
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
                presenter.alert.present(error: $0)
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
                presenter.alert.present(error: $0)
            }
        } label: {
            SectionGroup {
                RefdsText(
                    presenter.string(.save),
                    size: .small,
                    color: presenter.buttonForegroundColor,
                    weight: .bold
                )
            }
        }
    }
    
    private var buttonAddBudget: some View {
        NavigationLink(destination: AddBudgetScene(device: .macOS, presenter: AddBudgetPresenter.instance) {
            presenter.add(budget: $0) {
                presenter.alert.present(error: $0)
            }
        }) {
            SectionGroup {
                RefdsText(
                    presenter.string(.addBudget),
                    size: .small,
                    color: .accentColor,
                    weight: .bold
                )
            }
        }
    }
}

struct AddCategorymacOSView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                AddCategorymacOSView(presenter: AddCategoryPresenter.instance)
            }
            .previewDevice(PreviewDevice(rawValue: "iPad Air (5th generation)"))
        }
    }
}
