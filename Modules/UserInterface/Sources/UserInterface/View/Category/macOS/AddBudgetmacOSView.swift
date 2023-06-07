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
import Resource

struct AddBudgetmacOSView<Presenter: AddBudgetPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    private let newBudget: ((AddBudgetViewData) -> Void)?
    @Environment(\.dismiss) var dismiss
    
    init(newBudget: ((AddBudgetViewData) -> Void)? = nil) {
        self.newBudget = newBudget
    }
    
    var body: some View {
        AnyView(macView)
            .navigationTitle(presenter.string(.navigationTitle))
            .gesture(DragGesture().onChanged({ _ in Application.shared.endEditing() }))
            .task { await presenter.start(categoryID: presenter.category, budgetID: presenter.budget) }
    }
    
    private var macView: some View {
        MacUIView(maxAmount: 2) {
            Group {
                VStack {
                    rowCurrency
                    if !(presenter.viewData.categories?.isEmpty ?? true) { SectionGroup { rowCategory } }
                    buttonSave
                }
                VStack {
                    rowDescription
                    rowDate
                    Spacer()
                }
            }
        }
    }
        
    private var rowCurrency: some View {
        Group {
            if presenter.isStarted {
                RefdsCurrencyTextField(value: $presenter.viewData.amount, style: .custom(40), color: .primary, alignment: .center)
                    .padding()
            }
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
    
    private var rowDescription: some View {
        GroupBox {
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
        .listGroupBoxStyle()
    }
    
    private var rowCategory: some View {
        Group {
            if let name = presenter.viewData.category?.name,
               let color = presenter.viewData.category?.color,
               let categories = presenter.viewData.categories {
                CollapsedView { rowCategoryHeader(name: name, color: color) } content: {
                    rowCategoryOptions(categories: categories)
                }
            } else { buttonAddCategory }
        }
    }
    
    private func rowCategoryHeader(name: String, color: Color) -> some View {
        HStack(spacing: 15) {
            RefdsText(presenter.string(.category))
            Spacer()
            RefdsTag(name, style: .caption1, color: color)
        }
    }
    
    private func rowCategoryOptions(categories: [AddBudgetViewData.Category]) -> some View {
        VStack {
            ForEach(categories.indices, id: \.self) { index in
                let category = categories[index]
                categoryOptionView(category: category)
                if index < categories.count - 1 { Divider() }
            }
        }
    }
    
    private func categoryOptionView(category: AddBudgetViewData.Category) -> some View {
        RefdsButton { presenter.viewData.category = category } label: {
            HStack(spacing: 10) {
                RefdsIcon(symbol: category.icon, color: category.color, size: 12, weight: .medium, renderingMode: .hierarchical)
                    .frame(width: 18, height: 18)
                    .padding(.all, 5)
                    .background(category.color.opacity(0.2))
                    .cornerRadius(8)
                    .opacity(presenter.viewData.category?.id == category.id ? 1 : 0.2)
                RefdsText(category.name.capitalized)
                Spacer()
            }
            .padding(.vertical, 4)
        }
    }
    
    private var buttonAddCategory: some View {
        RefdsRow {
            HStack {
                RefdsText(presenter.string(.category))
                Spacer()
                RefdsText(presenter.string(.addNewCategory), color: .secondary, alignment: .trailing, lineLimit: 1)
            }
        } destination: { presenter.router.configure(routes: .addCategory) }
    }
    
    private var buttonSave: some View {
        RefdsButton(Strings.General.budgetSave.value, style: .secondary) {
            Application.shared.endEditing()
            presenter.add(budget: { budget in
                newBudget?(budget)
                dismiss()
            }, dismiss: { dismiss() })
        }
    }
}
