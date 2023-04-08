//
//  AddBudgetPresenter.swift
//  
//
//  Created by Rafael Santos on 25/02/23.
//

import SwiftUI
import Domain
import Resource

public enum AddBudgetPresenterString {
    case navigationTitle
    case placeholderDescription
    case description
}

public protocol AddBudgetPresenterProtocol: ObservableObject {
    var amount: Double { get set }
    var date: Date { get set }
    var description: String { get set }
    
    var buttonForegroundColor: Color { get }
    
    func string(_ string: AddBudgetPresenterString) -> String
    func add(budget: (BudgetEntity) -> Void)
}

public final class AddBudgetPresenter: AddBudgetPresenterProtocol {
    public static var instance: Self { Self() }
    
    @Published public var amount: Double = 0
    @Published public var date: Date = Date()
    @Published public var description: String = ""
    
    private var canAddNewBudget: Bool {
        return amount > 0
    }
    
    public var buttonForegroundColor: Color {
        return canAddNewBudget ? .accentColor : .secondary
    }
    
    public func string(_ string: AddBudgetPresenterString) -> String {
        switch string {
        case .navigationTitle: return Strings.AddBudget.navigationTitle.value
        case .placeholderDescription: return Strings.AddBudget.placeholderDescription.value
        case .description: return Strings.AddBudget.description.value
        }
    }
    
    public func add(budget: (BudgetEntity) -> Void) {
        if canAddNewBudget {
            budget(
                BudgetEntity(
                    date: date,
                    amount: amount,
                    description: description
                )
            )
        }
    }
}
