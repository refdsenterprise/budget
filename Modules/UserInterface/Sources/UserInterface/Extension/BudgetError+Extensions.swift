//
//  BudgetError+Extensions.swift
//  
//
//  Created by Rafael Santos on 24/02/23.
//

import Foundation
import RefdsUI
import Domain

public extension BudgetError {
    var alertTitle: String {
        switch self {
        case .existingCategory: return "Categoria existente"
        case .notFoundCategory: return "Categoria não encontrada"
        case .notFoundBudget: return "Budget não encontrado"
        case .existingTransaction: return "Transação existente"
        case .notFoundTransaction: return "Trasação não encontrada"
        case .cantDeleteCategory: return "Categoria não pode ser removida"
        case .cantDeleteBudget: return "Budget não pode ser removido"
        case .existingBudget: return "Budget existente"
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
        case .existingBudget: return "Já existe o budget para o mês informado"
        }
    }
    
    var alertIcon: RefdsIconSymbol {
        switch self {
        case .existingCategory: return .exclamationmarkTriangleFill
        case .notFoundCategory: return .exclamationmarkTriangleFill
        case .notFoundBudget: return .exclamationmarkTriangleFill
        case .existingTransaction: return .exclamationmarkTriangleFill
        case .notFoundTransaction: return .exclamationmarkTriangleFill
        case .cantDeleteCategory: return .exclamationmarkOctagonFill
        case .cantDeleteBudget: return .exclamationmarkOctagonFill
        case .existingBudget: return .exclamationmarkTriangleFill
        }
    }
}
