//
//  AddBudgetScene.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI
import RefdsUI

struct AddBudgetScene: View {
    @State private var categoryBudgetAmount: Double = 0
    @State private var categoryBudgetDate = Date()
    private var delegate: ((BudgetEntity) -> Void)?
    
    @Environment(\.dismiss) var dismiss
    
    init(delegate: ((BudgetEntity) -> Void)? = nil) {
        self.delegate = delegate
    }
    
    var body: some View {
        form
            .navigationTitle("Novo Budget")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        UIApplication.shared.endEditing()
                        if canAddNewBudget {
                            delegate?(.init(date: categoryBudgetDate, amount: categoryBudgetAmount))
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "checkmark.rectangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(buttonForegroundColor)
                    }
                }
            }
    }
    
    private var form: some View {
        Form {
            sectionAmount
        }
        .gesture(DragGesture().onChanged({ _ in UIApplication.shared.endEditing() }))
    }
    
    private var sectionAmount: some View {
        Section {
            sectionBudgetDate
        } header: {
            RefdsCurrency(value: $categoryBudgetAmount)
                .padding()
        }
    }
    
    private var sectionBudgetDate: some View {
        DatePicker("Informe o mês", selection: $categoryBudgetDate, displayedComponents: .date)
            .font(.refds(size: 16, scaledSize: 1.2 * 16))
            .datePickerStyle(.graphical)
        
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
