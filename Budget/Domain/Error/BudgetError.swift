//
//  BudgetError.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import Foundation
import SwiftUI
import RefdsUI

enum BudgetError: Error {
    case existingCategory
    case notFoundCategory
    case notFoundBudget
    case existingTransaction
    case notFoundTransaction
    case cantDeleteCategory
    case cantDeleteBudget
    
    var alertTitle: String {
        switch self {
        case .existingCategory: return "Categoria existente"
        case .notFoundCategory: return "Categoria não encontrada"
        case .notFoundBudget: return "Budget não encontrado"
        case .existingTransaction: return "Transação existente"
        case .notFoundTransaction: return "Trasação não encontrada"
        case .cantDeleteCategory: return "Categoria não pode ser removida"
        case .cantDeleteBudget: return "Budget não pode ser removido"
        }
    }
    
    var alertMessage: String {
        switch self {
        case .existingCategory: return "Já existe no sistema a categoria informada"
        case .notFoundCategory: return "Não foi possível encontrar a categoria"
        case .notFoundBudget: return "Não foi possível encontrar o budget"
        case .existingTransaction: return "Já existe no sistema a trasação informada"
        case .notFoundTransaction: return "Não foi possível encontrar a trasação"
        case .cantDeleteCategory: return "A categoria que deseja remover está sendo utilizada em alguma transação"
        case .cantDeleteBudget: return "O budget que deseja remover está sendo utilizado em alguma transação"
        }
    }
}

extension View {
    func alertBudgetError(isPresented: Binding<(Bool, BudgetError)>) -> some View {
        self.alert(isPresented.wrappedValue.1.alertTitle, isPresented: isPresented.0.projectedValue, actions: {  }, message: { RefdsText(isPresented.wrappedValue.1.alertMessage) })
    }
}
