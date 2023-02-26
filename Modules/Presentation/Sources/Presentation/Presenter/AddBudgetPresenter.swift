//
//  AddBudgetPresenter.swift
//  
//
//  Created by Rafael Santos on 25/02/23.
//

import SwiftUI

public final class AddBudgetPresenter: ObservableObject {
    public static var instance: Self { Self() }
    
    @Published public var categoryBudgetAmount: Double = 0
    @Published public var categoryBudgetDate = Date()
    
    public var canAddNewBudget: Bool {
        return categoryBudgetAmount > 0
    }
    
    public var buttonBackgroundColor: Color {
        return canAddNewBudget ? .accentColor.opacity(0.2) : .secondary.opacity(0.2)
    }
    
    public var buttonForegroundColor: Color {
        return canAddNewBudget ? .accentColor : .secondary
    }
}
