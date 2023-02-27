//
//  AddCategoryScene.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI
import Domain
import Presentation
import UserInterface

public struct AddCategoryScene: View {
    @StateObject private var presenter: AddCategoryPresenter
    @Environment(\.dismiss) var dismiss
    
    public init(category: CategoryEntity? = nil) {
        _presenter = StateObject(wrappedValue: AddCategoryPresenter(category: category))
    }
    
    public var body: some View {
        bodyView
            .navigationTitle(Strings.AddCategory.navigationTitle.value)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                        if !Application.isLargeScreen { buttonSave }
                        //buttonImport
                    }
                }
            }
            .gesture(DragGesture().onChanged({ _ in Application.shared.endEditing() }))
            .alertBudgetError(isPresented: $presenter.isPresentedAlert)
//            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.data]) { result in
//                switch result {
//                case .success(let url): Storage.shared.category.replaceAllCategories(try? Data(contentsOf: url))
//                case .failure(_): print("error import file")
//                }
//            }
    }
    
    private var bodyView: some View {
        Application.isLargeScreen ? AnyView(macView) : AnyView(phoneView)
    }
    
    private var macView: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: .columns(width: proxy.size.width, maxAmount: 2)) {
                    VStack {
                        GroupBox {
                            VStack {
                                rowName
                                Divider().padding(.horizontal)
                                rowColor
                            }
                        }
                        
                        GroupBox { buttonSave.frame(maxWidth: .infinity) }
                            .padding(.vertical, 15)
                        
                        Spacer()
                    }
                    
                    VStack {
                        if !presenter.budgets.isEmpty {
                            GroupBox {
                                ForEach(presenter.budgets, id: \.id) { budget in
                                    rowBudget(budget)
                                        .contextMenu { contextMenuRemoveBudget(budget) }
                                    if let index = presenter.budgets.firstIndex(of: budget), index != presenter.budgets.count - 1 {
                                        Divider().padding(.horizontal)
                                    }
                                }
                            }
                        }
                        
                        GroupBox {
                            NavigationLink(destination: AddBudgetScene { presenter.addBudget($0) }) {
                                HStack {
                                    RefdsText(Strings.AddCategory.buttonAddBudget.value, color: .accentColor, weight: .bold)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .padding(.vertical, presenter.budgets.isEmpty ? 0 : 15)
                        
                        Spacer()
                    }
                }
                .padding()
            }
        }
    }
    
    private var phoneView: some View {
        Form {
            sectionName
            sectionBudget
        }
    }
    
    private var sectionName: some View {
        Section {
            rowName
            rowColor
        } header: {
            RefdsText(Strings.AddCategory.headerCategory.value, size: .extraSmall, color: .secondary)
        }
    }
    
    private var rowName: some View {
        HStack {
            RefdsText(Strings.AddCategory.labelName.value)
            RefdsTextField(Strings.AddCategory.labelPlaceholderName.value, text: $presenter.name, alignment: .trailing, textInputAutocapitalization: .characters)
        }
    }
    
    private var rowColor: some View {
        HStack {
            RefdsText(Strings.AddCategory.labelColor.value)
            Spacer()
            ColorPicker(selection: $presenter.color, supportsOpacity: false) {}
        }
    }
    
    private var sectionBudget: some View {
        Section {
            rowBudget
        } header: {
            HStack {
                RefdsText(Strings.AddCategory.headerBudgets.value, size: .extraSmall, color: .secondary)
                Spacer()
            }
        }
    }
    
    private var rowBudget: some View {
        Group {
            if !presenter.budgets.isEmpty {
                ForEach(presenter.budgets, id: \.id) { budget in
                    rowBudget(budget)
                        .contextMenu { contextMenuRemoveBudget(budget) }
                }
                
            }
            NavigationLink(destination: AddBudgetScene { presenter.addBudget($0) }) {
                HStack {
                    RefdsText(Strings.AddCategory.buttonAddBudget.value, color: .accentColor, weight: .bold)
                }
            }
        }
    }
    
    private func rowBudget(_ budget: BudgetEntity) -> some View {
        HStack(spacing: 15) {
            RefdsText(budget.date.asString(withDateFormat: .custom("MMMM yyyy")).capitalized)
            Spacer()
            RefdsText(budget.amount.formatted(.currency(code: "BRL")), size: .normal, color: .secondary, weight: .medium, family: .moderatMono, lineLimit: 1)
        }
    }
    
    private func contextMenuRemoveBudget(_ budget: BudgetEntity) -> some View {
        Button {
            do { try presenter.removeBudget(budget) }
            catch { presenter.isPresentedAlert = (true, error as! BudgetError) }
        } label: {
            Label(Strings.AddCategory.buttonRemoveBudget.value, systemImage: RefdsIconSymbol.trashFill.rawValue)
        }
    }
    
    private var buttonSave: some View {
        Button {
            Application.shared.endEditing()
            if presenter.canAddNewBudget, !presenter.isEditMode { presenter.addCategory(onSuccess: { dismiss() }, onError: { presenter.isPresentedAlert = (true, $0) }) }
            else if presenter.canAddNewBudget, presenter.isEditMode { presenter.editCategory(onSuccess: { dismiss() }, onError: { presenter.isPresentedAlert = (true, $0) }) }
        } label: {
            if Application.isLargeScreen {
                RefdsText(Strings.General.save.value, color: presenter.buttonForegroundColor, weight: .bold)
            } else {
                RefdsIcon(
                    symbol: .checkmarkCircleFill,
                    color: presenter.buttonForegroundColor,
                    size: 20,
                    renderingMode: .hierarchical
                )
            }
        }
    }
    
    private var buttonImport: some View {
        Button {
            Application.shared.endEditing()
            presenter.isImporting = !presenter.isEditMode
        } label: {
            RefdsIcon(symbol: .squareAndArrowDown, color: presenter.buttonForegroundColor, size: 20, weight: .regular, renderingMode: .hierarchical)
        }
    }
}

struct AddCategoryScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { AddCategoryScene() }
    }
}
