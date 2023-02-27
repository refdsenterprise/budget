//
//  AddTransactionScene.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI

import Domain
import Presentation
import UserInterface

public struct AddTransactionScene: View {
    @StateObject private var presenter: AddTransactionPresenter
    @State private var isPresentedAlert = false
    @State private var showSelectedCategory = false
    @State private var document: DataDocument = .init()
    @State private var isImporting: Bool = false
    
    let addCategoryScene: () -> any View
    
    public init(transaction: TransactionEntity? = nil, addCategoryScene: @escaping () -> any View) {
        self._presenter = StateObject(wrappedValue: AddTransactionPresenter(transaction: transaction))
        self.addCategoryScene = addCategoryScene
    }
    
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        form
            .navigationTitle("Nova Transação")
            .onAppear { presenter.loadData() }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                        buttonSave
                        buttonImport
                    }
                }
            }
//            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.data]) { result in
//                switch result {
//                case .success(let url): Storage.shared.transaction.replaceAllTransactions(try? Data(contentsOf: url))
//                case .failure(_): print("error import file")
//                }
//            }
    }
    
    private var form: some View {
        Form {
            sectionCategory
            sectionAmount
        }
        .gesture(DragGesture().onChanged({ _ in Application.shared.endEditing() }))
    }
    
    private var sectionCategory: some View {
        Section {
            rowDescription
            rowCategory
            if showSelectedCategory {
                ForEach(presenter.getCategories(), id: \.id) { category in
                    Button {
                        presenter.category = category
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                showSelectedCategory.toggle()
                            }
                        }
                    } label: {
                        HStack(spacing: 10) {
                            IndicatorPointView(color: presenter.category?.id == category.id ? category.color : .secondary)
                            RefdsText(category.name.capitalized)
                            Spacer()
                            if let budget = category.budgets.first(where: { $0.date.asString(withDateFormat: .monthYear) == presenter.date.asString(withDateFormat: .monthYear) }) {
                                RefdsText(budget.amount.formatted(.currency(code: "BRL")), color: .secondary, family: .moderatMono)
                            }
                        }
                    }
                }
            }
        } header: {
            RefdsCurrency(value: Binding(get: { presenter.amount }, set: { presenter.amount = $0 }), size: .custom(40))
                .padding()
        }
    }
    
    private var sectionAmount: some View {
        rowDate
    }
    
    private var rowDate: some View {
        CollapsedView(showOptions: true, title: "Data e hora") {
            DatePicker("Informe o mês", selection: Binding(get: { presenter.date }, set: {
                presenter.loadData(newDate: $0)
                presenter.date = $0
            }), displayedComponents: [.date, .hourAndMinute])
                .font(.refds(size: 16, scaledSize: 1.2 * 16))
                .datePickerStyle(.graphical)
                .tint(presenter.category?.color ?? .accentColor)
        }
        .tint(presenter.category?.color ?? .accentColor)
    }
    
    private var rowDescription: some View {
        HStack {
            RefdsText("Descrição")
            Spacer()
            RefdsTextField("Informe a descrição", text: $presenter.description, alignment: .trailing, textInputAutocapitalization: .sentences)
        }
    }
    
    private var rowCategory: some View {
        VStack {
            if presenter.category != nil, let name = presenter.category?.name, let color = presenter.category?.color {
                Button {
                    withAnimation {
                        showSelectedCategory.toggle()
                    }
                } label: {
                    HStack(spacing: 15) {
                        Image(systemName: "chevron.up")
                            .font(.system(size: 16, weight: .bold))
                            .rotationEffect(showSelectedCategory ? .degrees(0) : .degrees(180))
                        RefdsText("Categoria")
                        Spacer()
                        RefdsTag(name, size: .extraSmall, color: color)
                    }
                }
                .tint(presenter.category?.color ?? .accentColor)
            } else {
                NavigationLink { AnyView(addCategoryScene()) } label: {
                    HStack {
                        RefdsText("Categoria")
                        Spacer()
                        RefdsText("Adicionar nova categoria", color: .secondary, alignment: .trailing, lineLimit: 1)
                    }
                }
            }
        }
    }
    
    private var buttonImport: some View {
        Button {
            Application.shared.endEditing()
            isImporting.toggle()
        } label: {
            Image(systemName: "square.and.arrow.down")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(presenter.buttonForegroundColor)
        }
    }
    
    private var buttonSave: some View {
        Button {
            Application.shared.endEditing()
            if presenter.canAddNewTransaction {
                if presenter.transaction != nil {
                    do {
                        try presenter.editTransaction()
                        dismiss()
                    } catch {
                        isPresentedAlert.toggle()
                    }
                } else {
                    do {
                        try presenter.addTransaction()
                        dismiss()
                    } catch {
                        isPresentedAlert.toggle()
                    }
                }
            }
        } label: {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 25)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(presenter.buttonForegroundColor)
        }
    }
}

struct AddTransactionScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { AddTransactionScene { EmptyView() } }
    }
}