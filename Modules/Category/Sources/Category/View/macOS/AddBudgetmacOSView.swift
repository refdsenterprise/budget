//
//  AddBudgetmacOSView.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI
import RefdsUI
import Domain
import Presentation
import UserInterface
import Resource

struct AddBudgetmacOSView<Presenter: AddBudgetPresenterProtocol>: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var presenter: Presenter
    private let newBudget: (BudgetEntity) -> Void
    
    init(presenter: Presenter, newBudget: @escaping (BudgetEntity) -> Void) {
        self._presenter = StateObject(wrappedValue: presenter)
        self.newBudget = newBudget
    }
    
    var body: some View {
        AnyView(macView)
            .navigationTitle(Strings.AddBudget.navigationTitle.value)
            .gesture(DragGesture().onChanged({ _ in Application.shared.endEditing() }))
    }
    
    private var macView: some View {
        MacUIView(maxAmount: 2) {
            Group {
                VStack {
                    rowCurrency
                    buttonSave
                }
                VStack {
                    rowDescription
                    rowDate
                }
            }
        }
    }
        
    private var rowCurrency: some View {
        RefdsCurrency(
            value: $presenter.amount,
            size: .custom(40)
        )
        .padding()
    }
    
    private var rowDate: some View {
        DatePicker(
            .empty,
            selection: $presenter.date,
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
    }
    
    private var rowDescription: some View {
        GroupBox {
            HStack {
                RefdsText(presenter.stringDescription)
                Spacer()
                RefdsTextField(presenter.stringPlaceholderDescription, text: $presenter.description, alignment: .trailing)
            }
        }
        .listGroupBoxStyle()
    }
    
    private var buttonSave: some View {
        Button {
            Application.shared.endEditing()
            presenter.add { budget in
                newBudget(budget)
                dismiss()
            }
        } label: {
            GroupBox {
                RefdsText(
                    Strings.General.budgetSave.value.uppercased(),
                    size: .small,
                    color: presenter.buttonForegroundColor,
                    weight: .bold
                )
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical)
            .listGroupBoxStyle()
        }
    }
}

struct AddBudgetmacOSView_Previews: PreviewProvider {
    static var previews: some View {
        AddBudgetmacOSView(presenter: AddBudgetPresenter.instance) { _ in }
            .previewDevice(PreviewDevice(rawValue: "iPad Air (5th generation)"))
    }
}
