//
//  AddTransactioniOSView.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import SwiftUI
import RefdsUI
import Presentation

struct AddTransactioniOSView<Presenter: AddTransactionPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            sectionInformation
            sectionDate
        }
        .budgetAlert($presenter.alert)
        .navigationTitle(presenter.string(.navigationTitle))
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { buttonSave } }
        .gesture(DragGesture().onChanged({ _ in Application.shared.endEditing() }))
        .task {
            await presenter.start(transaction: presenter.transaction)
            presenter.loadData()
        }
    }
    
    private var sectionInformation: some View {
        Section {
            rowDescription
            rowCategory
        } header: {
            if presenter.isStarted {
                RefdsCurrencyTextField(value: $presenter.amount, size: .custom(40), color: .primary, alignment: .center)
                    .padding()
            }
        }
    }
    
    private var rowDescription: some View {
        HStack {
            RefdsText(presenter.string(.description))
            Spacer()
            RefdsTextField(
                presenter.string(.inputDescription),
                text: $presenter.viewData.message,
                alignment: .trailing,
                textInputAutocapitalization: .sentences
            )
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
        
    private func rowCategoryOptions(categories: [AddTransactionViewData.Category]) -> some View {
        ForEach(categories, id: \.id) { category in
            Button { presenter.viewData.category = category } label: {
                HStack(spacing: 10) {
                    IndicatorPointView(color: presenter.viewData.category?.id == category.id ? category.color : .secondary)
                    RefdsText(category.name.capitalized)
                    Spacer()
                    RefdsText(
                        category.remaning.currency,
                        color: .secondary,
                        family: .moderatMono
                    )
                }
            }
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
    
    private var sectionDate: some View {
        Section {
            CollapsedView(
                showOptions: true,
                title: presenter.string(.dateAndTime),
                description: presenter.date.asString(withDateFormat: .custom("EEE dd, MMM yyyy")).capitalized
            ) {
                DatePicker(.empty, selection: $presenter.date, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.graphical)
            }
        }
    }
    
    private var buttonSave: some View {
        Button {
            Application.shared.endEditing()
            presenter.save { dismiss() } onError: {
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
}
