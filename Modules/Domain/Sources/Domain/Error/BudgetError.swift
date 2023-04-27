//
//  BudgetError.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import Foundation
import RefdsUI

public enum BudgetError: Error {
    case existingCategory
    case notFoundCategory
    case notFoundBudget
    case existingTransaction
    case notFoundTransaction
    case cantDeleteCategory
    case cantDeleteBudget
    case existingBudget
    case cantSaveOnDatabase
    case dontAcceptedTerms
    case notFoundProducts
    case cantAddCategoryPro
    
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
        case .cantSaveOnDatabase: return "Erro ao salvar"
        case .dontAcceptedTerms: return "Aceite os termos"
        case .notFoundProducts: return "Erro ao carregar Pro"
        case .cantAddCategoryPro: return "Limite de Categorias Excedido"
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
        case .cantSaveOnDatabase: return "Não foi possível persistir a informação no dispositivo"
        case .dontAcceptedTerms: return "Só é possível realizar a assinatura após o aceite dos termos."
        case .notFoundProducts: return "Verifique sua conexão com a internet para prosseguir com a compra."
        case .cantAddCategoryPro: return "Para adicionar mais categorias se torne Pro."
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
        case .cantSaveOnDatabase: return .externaldriveFillBadgeExclamationmark
        case .dontAcceptedTerms: return .exclamationmarkTriangleFill
        case .notFoundProducts: return .wifiExclamationmark
        case .cantAddCategoryPro: return .exclamationmarkOctagonFill
        }
    }
}
