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

struct AddBudgetiOSView<Presenter: AddBudgetPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    private let newBudget: ((AddBudgetViewData) -> Void)?
    @Environment(\.dismiss) var dismiss
    
    init(newBudget: ((AddBudgetViewData) -> Void)? = nil) {
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
            if !(presenter.viewData.categories?.isEmpty ?? true) { rowCategory }
            rowDate
        } header: {
            rowCurrency
        }
    }
    
    private var rowCategory: some View {
        Group {
            if let name = presenter.viewData.category?.name, let categories = presenter.viewData.categories {
                CollapsedView(title: presenter.string(.category), description: name.capitalized) {
                    rowCategoryOptions(categories: categories)
                }
            } else { buttonAddCategory }
        }
    }
    
    private var buttonAddCategory: some View {
        NavigationLink { presenter.router.configure(routes: .addCategory) } label: {
            HStack {
                RefdsText(presenter.string(.category))
                Spacer()
                RefdsText(presenter.string(.addNewCategory), color: .secondary, alignment: .trailing, lineLimit: 1)
            }
        }
    }
    
    private func rowCategoryOptions(categories: [AddBudgetViewData.Category]) -> some View {
        ForEach(categories, id: \.id) { category in
            Button { presenter.viewData.category = category } label: {
                HStack(spacing: 10) {
                    IndicatorPointView(color: category.color)
                    RefdsText(category.name.capitalized)
                    Spacer()
                }
            }
        }
    }
    
    private var rowCurrency: some View {
        RefdsCurrency(
            value: $presenter.viewData.amount,
            size: .custom(40)
        )
        .padding()
    }
    
    private var rowDescription: some View {
        HStack {
            RefdsText(presenter.string(.description))
            Spacer()
            RefdsTextField(
                presenter.string(.placeholderDescription),
                text: $presenter.viewData.message,
                alignment: .trailing
            )
        }
    }
    
    private var rowDate: some View {
        DatePicker(
            .empty,
            selection: $presenter.viewData.date,
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
            RefdsIcon(
                symbol: .checkmarkRectangleFill,
                color: presenter.buttonForegroundColor,
                size: 20,
                weight: .medium,
                renderingMode: .hierarchical
            )
        }
    }
}
