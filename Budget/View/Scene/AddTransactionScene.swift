//
//  AddTransactionScene.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI

struct AddTransactionScene: View {
    @StateObject private var presenter: AddTransactionPresenter = .instance
    @State private var isPresentedAlert = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        form
            .navigationTitle("Nova Transação")
            .onAppear { presenter.loadData() }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        UIApplication.shared.endEditing()
                        if presenter.canAddNewTransaction {
                            do {
                                try Storage.shared.transaction.addTransaction(date: presenter.date, description: presenter.description, category: presenter.category!, amount: presenter.amount)
                                dismiss()
                            } catch {
                                isPresentedAlert.toggle()
                            }
                        }
                    } label: {
                        Image(systemName: "checkmark.rectangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(presenter.buttonForegroundColor)
                    }
                }
            }
            .refdsAlert(title: "Erro ao criar transação", message: "A transação que está criando já consta no sistema.", isPresented: $isPresentedAlert)
    }
    
    private var form: some View {
        Form {
            sectionAmount
        }
        .gesture(DragGesture().onChanged({ _ in UIApplication.shared.endEditing() }))
    }
    
    private var sectionAmount: some View {
        Section {
            rowCategory
            rowDescription
            rowDate
        } header: {
            RefdsCurrency(value: Binding(get: { presenter.amount }, set: { presenter.amount = $0 }))
                .padding()
        }
    }
    
    private var rowDate: some View {
        DatePicker("Informe o mês", selection: Binding(get: { presenter.date }, set: { presenter.date = $0; presenter.loadData() }), displayedComponents: .date)
            .font(.refds(size: 16, scaledSize: 1.2 * 16))
            .datePickerStyle(.graphical)
    }
    
    private var rowDescription: some View {
        HStack {
            RefdsText("Descrição")
            Spacer()
            RefdsTextField("Informe a descrição (Opicional)", text: $presenter.description, alignment: .trailing, textInputAutocapitalization: .sentences)
        }
    }
    
    private var rowCategory: some View {
        VStack {
            if presenter.category != nil, let categories = presenter.getCategories() {
                Picker(selection: Binding(get: { presenter.selectionCategory }, set: { presenter.selectionCategory = $0; presenter.category = categories[$0] })) {
                    ForEach(0 ..< categories.count, id: \.self) { index in
                        RefdsText(categories[index].name.capitalized, color: .accentColor, weight: .bold)
                    }
                } label: {
                    RefdsText("Categoria")
                }
            } else {
                NavigationLink {
                    AddCategoryScene()
                } label: {
                    HStack {
                        RefdsText("Categoria")
                        Spacer()
                        RefdsText("Adicionar nova categoria", color: .secondary, alignment: .trailing, lineLimit: 1)
                    }
                }
            }
        }
    }
}

struct AddTransactionScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { AddTransactionScene() }
    }
}
