//
//  AddCategoryScene.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI

struct AddCategoryScene: View {
    @StateObject private var presenter: AddCategoryPresenter
    @State private var isPresentedAddBudget = false
    @State private var isPresentedAlert: (Bool, BudgetError) = (false, .notFoundCategory)
    private var isEditMode: Bool
    @State private var document: DataDocument = .init()
    @State private var isImporting: Bool = false
    @Environment(\.dismiss) var dismiss
    
    init(category: CategoryEntity? = nil) {
        isEditMode = category != nil
        _presenter = StateObject(wrappedValue: AddCategoryPresenter(category: category))
    }
    
    var body: some View {
        form
            .navigationTitle("Nova Categoria")
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.data]) { result in
                switch result {
                case .success(let url): Storage.shared.category.replaceAllCategories(try? Data(contentsOf: url))
                case .failure(_): print("error import file")
                }
            }
            .alertBudgetError(isPresented: $isPresentedAlert)
    }
    
    private var form: some View {
        Form {
            sectionCategoryName
            sectionBudget
            sectionSave
        }
        .gesture(DragGesture().onChanged({ _ in Application.shared.endEditing() }))
    }
    
    private var sectionCategoryName: some View {
        Section {
            HStack {
                RefdsText("Nome")
                RefdsTextField("Informe o nome da categoria", text: $presenter.name, alignment: .trailing, textInputAutocapitalization: .characters)
            }
            sectionCategoryColor
        } header: {
            RefdsText("categoria", size: .extraSmall, color: .secondary)
        }
    }
    
    private var sectionCategoryColor: some View {
        HStack {
            RefdsText("Cor")
            Spacer()
            ColorPicker(selection: $presenter.color, supportsOpacity: false) {
            }
        }
    }
    
    private var sectionBudget: some View {
        Section {
            if !presenter.budgets.isEmpty {
                ForEach(presenter.budgets, id: \.id) { budget in
                    rowBudget(budget)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) { swipeRemoveBudget(budget) }
                }
                
            }
            NavigationLink(destination: AddBudgetScene { presenter.addBudget($0) }) {
                HStack {
                    RefdsText("Adicionar novo budget", color: .accentColor, weight: .bold)
                }
            }
        } header: {
            HStack {
                RefdsText("Budgets", size: .extraSmall, color: .secondary)
                Spacer()
            }
        }
    }
    
    private func rowBudget(_ budget: BudgetEntity) -> some View {
        HStack(spacing: 15) {
            RefdsText(budget.date.asString(withDateFormat: "MMMM yyyy").capitalized)
            Spacer()
            RefdsText(budget.amount.formatted(.currency(code: "BRL")), size: .normal, color: .secondary, weight: .medium, family: .moderatMono, lineLimit: 1)
        }
    }
    
    private func swipeRemoveBudget(_ budget: BudgetEntity) -> some View {
        Button {
            do { try presenter.removeBudget(budget) }
            catch { isPresentedAlert = (true, error as! BudgetError) }
        } label: {
            Image(systemName: "trash.fill")
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
        }
        .tint(.pink)
    }
    
    private var sectionSave: some View {
        Section {
            Button {
                Application.shared.endEditing()
                if presenter.canAddNewBudget, !isEditMode { presenter.addCategory(onSuccess: { dismiss() }, onError: { isPresentedAlert = (true, $0) }) }
                else if presenter.canAddNewBudget, isEditMode { presenter.editCategory(onSuccess: { dismiss() }, onError: { isPresentedAlert = (true, $0) }) }
            } label: {
                RefdsText("Salvar alterações", color: presenter.buttonForegroundColor, weight: .bold)
            }
        }
    }
    
    private var buttonImport: some View {
        Button {
            Application.shared.endEditing()
            isImporting = !isEditMode
        } label: {
            Image(systemName: "square.and.arrow.down")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(presenter.buttonForegroundColor)
        }
    }
}

struct AddCategoryScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { AddCategoryScene() }
    }
}
