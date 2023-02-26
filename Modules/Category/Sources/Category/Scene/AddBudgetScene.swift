//
//  AddBudgetScene.swift
//  Budget
//
//  Created by Rafael Santos on 31/12/22.
//

import SwiftUI
import RefdsUI
import Domain
import Presentation
import UserInterface

public struct AddBudgetScene: View {
    @StateObject private var presenter: AddBudgetPresenter = .instance
    private let newBudget: (BudgetEntity) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    public init(newBudget: @escaping (BudgetEntity) -> Void) {
        self.newBudget = newBudget
    }
    
    public var body: some View {
        bodyView
            .navigationTitle(Strings.AddBudget.navigationTitle.value)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !Application.isLargeScreen { buttonSave }
                }
            }
            .gesture(DragGesture().onChanged({ _ in Application.shared.endEditing() }))
    }
    
    private var bodyView: some View {
        Application.isLargeScreen ? AnyView(macView) : AnyView(phoneView)
    }
    
    private var macView: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: .columns(width: proxy.size.width, maxAmount: 2)) {
                    VStack {
                        rowCurrency
                        GroupBox { buttonSave }.padding()
                    }
                    rowDate
                }
                .padding()
            }
        }
    }
    
    private var phoneView: some View {
        Form {
            sectionAmount
        }
    }
    
    private var sectionAmount: some View {
        Section {
            rowDate
        } header: {
            rowCurrency
        }
    }
    
    private var rowCurrency: some View {
        RefdsCurrency(value: $presenter.categoryBudgetAmount, size: .custom(40))
            .padding()
    }
    
    private var rowDate: some View {
        DatePicker(.empty, selection: $presenter.categoryBudgetDate, displayedComponents: .date)
            .font(.refds(size: 16, scaledSize: 1.2 * 16))
            .datePickerStyle(.graphical)
        
    }
    
    private var buttonSave: some View {
        Button {
            Application.shared.endEditing()
            if presenter.canAddNewBudget {
                newBudget(.init(date: presenter.categoryBudgetDate, amount: presenter.categoryBudgetAmount))
                dismiss()
            }
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
}

struct AddBudgetScene_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddBudgetScene { _ in }
        }
    }
}
