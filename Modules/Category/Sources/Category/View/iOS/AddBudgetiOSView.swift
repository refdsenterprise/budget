//
//  AddBudgetiOSView.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI
import RefdsUI
import Domain
import Presentation
import UserInterface

struct AddBudgetiOSView<Presenter: AddBudgetPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    private let newBudget: ((BudgetEntity) -> Void)?
    @Environment(\.dismiss) var dismiss
    
    init(newBudget: ((BudgetEntity) -> Void)? = nil) {
        self.newBudget = newBudget
    }
    
    var body: some View {
        List {
            sectionAmount
        }
        .navigationTitle(presenter.string(.navigationTitle))
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { buttonSave } }
        .gesture(DragGesture().onChanged({ _ in Application.shared.endEditing() }))
    }
    
    private var sectionAmount: some View {
        Section {
            rowDescription
            rowDate
        } header: {
            rowCurrency
        }
    }
    
    private var rowCurrency: some View {
        RefdsCurrency(
            value: $presenter.amount,
            size: .custom(40)
        )
        .padding()
    }
    
    private var rowDescription: some View {
        HStack {
            RefdsText(presenter.string(.description))
            Spacer()
            RefdsTextField(presenter.string(.placeholderDescription), text: $presenter.description, alignment: .trailing)
        }
    }
    
    private var rowDate: some View {
        DatePicker(
            .empty,
            selection: $presenter.date,
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
    }
    
    private var buttonSave: some View {
        Button {
            Application.shared.endEditing()
            presenter.add { budget in
                newBudget?(budget)
                dismiss()
            }
        } label: {
            RefdsIcon(symbol: .checkmarkRectangleFill, color: presenter.buttonForegroundColor, size: 20, weight: .medium, renderingMode: .hierarchical)
        }
    }
}
