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
    @EnvironmentObject private var presenter: Presenter
    private let newBudget: ((BudgetEntity) -> Void)?
    @Environment(\.dismiss) var dismiss
    
    init(newBudget: ((BudgetEntity) -> Void)? = nil) {
        self.newBudget = newBudget
    }
    
    var body: some View {
        AnyView(macView)
            .navigationTitle(presenter.string(.navigationTitle))
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
                RefdsText(presenter.string(.description))
                Spacer()
                RefdsTextField(presenter.string(.placeholderDescription), text: $presenter.description, alignment: .trailing)
            }
        }
        .listGroupBoxStyle()
    }
    
    private var buttonSave: some View {
        Button {
            Application.shared.endEditing()
            presenter.add { budget in
                newBudget?(budget)
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
