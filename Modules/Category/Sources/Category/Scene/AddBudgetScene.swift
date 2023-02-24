//
//  AddBudgetScene.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI
import RefdsUI
import Domain
import Core

public struct AddBudgetScene: View {
    @State private var categoryBudgetAmount: Double = 0
    @State private var categoryBudgetDate = Date()
    private var delegate: ((BudgetEntity) -> Void)?
    
    @Environment(\.dismiss) var dismiss
    
    public init(delegate: ((BudgetEntity) -> Void)? = nil) {
        self.delegate = delegate
    }
    
    public var body: some View {
        form
            .navigationTitle("Novo Budget")
    }
    
    private var form: some View {
        Form {
            sectionAmount
            sectionSave
        }
        .gesture(DragGesture().onChanged({ _ in Application.shared.endEditing() }))
    }
    
    private var sectionAmount: some View {
        Section {
            sectionBudgetDate
        } header: {
            RefdsCurrency(value: $categoryBudgetAmount, size: .custom(40))
                .padding()
        }
    }
    
    private var sectionBudgetDate: some View {
        DatePicker("Informe o mês", selection: $categoryBudgetDate, displayedComponents: .date)
            .font(.refds(size: 16, scaledSize: 1.2 * 16))
            .datePickerStyle(.graphical)
        
    }
    
    private var sectionSave: some View {
        Section {
            Button {
                Application.shared.endEditing()
                if canAddNewBudget {
                    delegate?(.init(date: categoryBudgetDate, amount: categoryBudgetAmount))
                    dismiss()
                }
            } label: {
                RefdsText("Salvar alterações", color: buttonForegroundColor, weight: .bold)
            }
        }
    }
    
    private var canAddNewBudget: Bool {
        return categoryBudgetAmount > 0 && delegate != nil
    }
    
    private var buttonBackgroundColor: Color {
        return canAddNewBudget ? .accentColor.opacity(0.2) : .secondary.opacity(0.2)
    }
    
    private var buttonForegroundColor: Color {
        return canAddNewBudget ? .accentColor : .secondary
    }
}

struct AddBudgetScene_Previews: PreviewProvider {
    static var previews: some View {
        AddBudgetScene()
    }
}
