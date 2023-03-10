//
//  AddBudgetPresenter.swift
//  
//
//  Created by Rafael Santos on 25/02/23.
//

import SwiftUI
import Domain
import Resource

public protocol AddBudgetPresenterProtocol: ObservableObject {
    var amount: Double { get set }
    var date: Date { get set }
    var description: String { get set }
    var stringNavigationTitle: String { get }
    var stringPlaceholderDescription: String { get }
    var stringDescription: String { get }
    var buttonForegroundColor: Color { get }
    
    func add(budget: (BudgetEntity) -> Void)
}

public final class AddBudgetPresenter: AddBudgetPresenterProtocol {
    public static var instance: Self { Self() }
    
    @Published public var amount: Double = 0
    @Published public var date: Date = Date()
    @Published public var description: String = ""
    
    public var stringNavigationTitle: String {
        return Strings.AddBudget.navigationTitle.value
    }
    
    public var stringPlaceholderDescription: String {
        return Strings.AddBudget.placeholderDescription.value
    }
    
    public var stringDescription: String {
        return Strings.AddBudget.description.value
    }
    
    private var canAddNewBudget: Bool {
        return amount > 0
    }
    
    public var buttonForegroundColor: Color {
        return canAddNewBudget ? .accentColor : .secondary
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
