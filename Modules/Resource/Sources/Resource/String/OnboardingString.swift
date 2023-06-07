//
//  OnboardingString.swift
//  
//
//  Created by Rafael Santos on 07/06/23.
//

import Foundation

public extension Strings {
    enum Onboarding {
        case categoryTitle
        case categoryDescription
        case categoryKeywords
        case budgetTitle
        case budgetDescription
        case budgetKeywords
        case transactionTitle
        case transactionDescription
        case transactionKeywords
        case category
        case transactions
        case transactionDescriptionPlaceholder
        case next
        case previous
        case getStart
        case onboarding
        
        private var key: String {
            switch self {
            case .categoryTitle: return "onboarding.categoryTitle"
            case .categoryDescription: return "onboarding.categoryDescription"
            case .categoryKeywords: return "onboarding.categoryKeywords"
            case .budgetTitle: return "onboarding.budgetTitle"
            case .budgetDescription: return "onboarding.budgetDescription"
            case .budgetKeywords: return "onboarding.budgetKeywords"
            case .transactionTitle: return "onboarding.transactionTitle"
            case .transactionDescription: return "onboarding.transactionDescription"
            case .transactionKeywords: return "onboarding.transactionKeywords"
            case .category: return "onboarding.category"
            case .transactions: return "onboarding.transactions"
            case .transactionDescriptionPlaceholder: return "onboarding.transactionDescriptionPlaceholder"
            case .next: return "onboarding.next"
            case .previous: return "onboarding.previous"
            case .getStart: return "onboarding.getStart"
            case .onboarding: return "onboarding.onboarding"
            }
        }
        
        public var value: String {
            NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: "")
        }
    }
}
