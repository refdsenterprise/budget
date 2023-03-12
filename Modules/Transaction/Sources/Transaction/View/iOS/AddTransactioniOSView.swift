//
//  AddTransactioniOSView.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import SwiftUI
import RefdsUI
import Presentation
import UserInterface

struct AddTransactioniOSView<Presenter: AddTransactionPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    @EnvironmentObject private var appConfigurator: AppConfiguration
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            sectionInformation
            sectionDate
        }
        .budgetAlert($presenter.alert)
        .navigationTitle(presenter.string(.navigationTitle))
        .onAppear { presenter.loadData() }
        .onDisappear { appConfigurator.themeColor = .accentColor }
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { buttonSave } }
        .gesture(DragGesture().onChanged({ _ in Application.shared.endEditing() }))
    }
    
    private var sectionInformation: some View {
        Section {
            rowDescription
            rowCategory
        } header: {
            RefdsCurrency(value: $presenter.amount, size: .custom(40))
                .padding()
        }
    }
    
    private var rowDescription: some View {
        HStack {
            RefdsText(presenter.string(.description))
            Spacer()
            RefdsTextField(
                presenter.string(.inputDescription),
                text: $presenter.description,
                alignment: .trailing,
                textInputAutocapitalization: .sentences
            )
        }
    }
    
    private var rowCategory: some View {
        Group {
            if let name = presenter.category?.name,
               let color = presenter.category?.color {
                CollapsedView { rowCategoryHeader(name: name, color: color) } content: { rowCategoryOptions }
            } else { buttonAddCategory }
        }
    }
    
    private func rowCategoryHeader(name: String, color: Color) -> some View {
        HStack(spacing: 15) {
            RefdsText(presenter.string(.category))
            Spacer()
            RefdsTag(name, size: .extraSmall, color: color)
        }
    }
        
    private var rowCategoryOptions: some View {
        ForEach(presenter.getCategories(), id: \.id) { category in
            Button {
                presenter.category = category
                appConfigurator.themeColor = category.color
            } label: {
                HStack(spacing: 10) {
                    IndicatorPointView(color: presenter.category?.id == category.id ? category.color : .secondary)
                    RefdsText(category.name.capitalized)
                    Spacer()
                    if let budget = presenter.getBudget(on: category) {
                        RefdsText(
                            budget.amount.currency,
                            color: .secondary,
                            family: .moderatMono
                        )
                    }
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
                DatePicker(.empty, selection: Binding(get: { presenter.date }, set: {
                    presenter.loadData(newDate: $0)
                    presenter.date = $0
                }), displayedComponents: [.date, .hourAndMinute])
                .font(.refds(size: 16, scaledSize: 1.2 * 16))
                .datePickerStyle(.graphical)
            }
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
}
