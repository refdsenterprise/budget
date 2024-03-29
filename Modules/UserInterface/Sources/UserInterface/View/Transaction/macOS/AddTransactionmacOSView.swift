//
//  AddTransactionmacOSView.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import SwiftUI
import RefdsUI
import Domain
import Presentation

struct AddTransactionmacOSView<Presenter: AddTransactionPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    @EnvironmentObject private var appConfigurator: AppConfiguration
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        MacUIView(sections: [
            .init(maxAmount: 2, content: {
                Group {
                    sectionInformation
                    sectionDate
                }
            })
        ])
        .budgetAlert($presenter.alert)
        .navigationTitle(presenter.string(.navigationTitle))
        .toolbar { ToolbarItem { buttonSave } }
        .gesture(DragGesture().onChanged({ _ in Application.shared.endEditing() }))
        .task {
            await presenter.start(transaction: presenter.transaction)
            presenter.loadData()
        }
    }
    
    private var sectionInformation: some View {
        VStack {
            if presenter.isStarted {
                RefdsCurrencyTextField(value: $presenter.amount, style: .custom(40), color: .primary, alignment: .center)
                    .padding()
            }
            rowInformation
            Spacer()
        }
    }
    
    private var rowInformation: some View {
        SectionGroup {
            Group {
                rowDescription
                rowCategory
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
                alignment: .trailing
            )
        }
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
    
    private func rowCategoryOptions(categories: [AddTransactionViewData.Category]) -> some View {
        VStack {
            ForEach(categories.indices, id: \.self) { index in
                let category = categories[index]
                categoryOptionView(category: category)
                if index < categories.count - 1 { Divider() }
            }
        }
    }
    
    private func categoryOptionView(category: AddTransactionViewData.Category) -> some View {
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
                RefdsText(
                    category.remaning.currency,
                    color: .secondary
                )
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
    
    private var sectionDate: some View {
        VStack {
            SectionGroup {
                CollapsedView(
                    showOptions: true,
                    title: presenter.string(.dateAndTime),
                    description: presenter.date.asString(withDateFormat: .custom("EEE dd, MMM yyyy")).capitalized
                ) {
                    DatePicker(.empty, selection: $presenter.date, displayedComponents: [.date, .hourAndMinute])
                        .font(.refds(size: 16, scaledSize: 1.2 * 16))
                        .datePickerStyle(.graphical)
                }
            }
            Spacer()
        }
    }
    
    private var buttonSave: some View {
        RefdsButton {
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
