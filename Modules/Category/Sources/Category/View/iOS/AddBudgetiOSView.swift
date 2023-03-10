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
    @Environment(\.dismiss) var dismiss
    @StateObject private var presenter: Presenter
    private let newBudget: (BudgetEntity) -> Void
    
    init(presenter: Presenter, newBudget: @escaping (BudgetEntity) -> Void) {
        self._presenter = StateObject(wrappedValue: presenter)
        self.newBudget = newBudget
    }
    
    var body: some View {
        List {
            sectionAmount
        }
        .navigationTitle(presenter.stringNavigationTitle)
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
            RefdsText(presenter.stringDescription)
            Spacer()
            RefdsTextField(presenter.stringPlaceholderDescription, text: $presenter.description, alignment: .trailing)
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
                newBudget(budget)
                dismiss()
            }
        } label: {
            RefdsIcon(symbol: .checkmarkRectangleFill, color: presenter.buttonForegroundColor, size: 20, weight: .medium, renderingMode: .hierarchical)
        }
    }
}

struct AddBudgetiOSView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddBudgetiOSView(presenter: AddBudgetPresenter.instance) { _ in }
                .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
        }
    }
}
