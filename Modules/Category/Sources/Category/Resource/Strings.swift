//
//  Strings.swift
//  
//
//  Created by Rafael Santos on 25/02/23.
//

import Foundation

public struct Strings { }

// MARK: - Add Budget
public extension Strings {
    enum AddBudget {
        case navigationTitle
        case infoMonth
        
        private var key: String {
            switch self {
            case .navigationTitle: return "addBudget.navigation.title"
            case .infoMonth: return "addBudget.infoMonth"
            }
        }
        
        public var value: String {
            NSLocalizedString(key, tableName: "Category", bundle: .module, comment: "")
        }
    }
}

// MARK: - Add Category
public extension Strings {
    enum AddCategory {
        case navigationTitle
        case buttonAddBudget
        case labelName
        case labelColor
        case labelPlaceholderName
        case headerCategory
        case headerBudgets
        case buttonRemoveBudget
        
        private var key: String {
            switch self {
            case .navigationTitle: return "addCategory.navigation.title"
            case .buttonAddBudget: return "addCategory.button.addBudget"
            case .labelName: return "addCategory.label.name"
            case .labelColor: return "addCategory.label.color"
            case .labelPlaceholderName: return "addCategory.label.placeholder.name"
            case .headerCategory: return "addCategory.header.category"
            case .headerBudgets: return "addCategory.header.budgets"
            case .buttonRemoveBudget: return "addCategory.button.removeBudget"
            }
        }
        
        public var value: String {
            NSLocalizedString(key, tableName: "Category", bundle: .module, comment: "")
        }
    }
}

// MARK: - Category
public extension Strings {
    enum Category {
        case navigationTitle
        case searchPlaceholder
        case sectionOptions
        case sectionOptionsFilterPerDate
        case sectionOptionsPeriod
        case sectionDuplicateNotFound
        case sectionDuplicateSuggestion
        case sectionDuplicateButton
        
        private var key: String {
            switch self {
            case .navigationTitle: return "category.navigation.title"
            case .searchPlaceholder: return "category.search.placeholder"
            case .sectionOptions: return "category.section.options"
            case .sectionOptionsFilterPerDate: return "category.section.options.filterPerDate"
            case .sectionOptionsPeriod: return "category.section.options.period"
            case .sectionDuplicateNotFound: return "category.section.duplicate.notFound"
            case .sectionDuplicateSuggestion: return "category.section.duplicate.suggestion"
            case .sectionDuplicateButton: return "category.section.duplicate.button"
            }
        }
        
        public var value: String {
            NSLocalizedString(key, tableName: "Category", bundle: .module, comment: "")
        }
    }
}

// MARK: - General
public extension Strings {
    enum General {
        case save
        
        private var key: String {
            switch self {
            case .save: return "save.button"
            }
        }
        
        public var value: String {
            NSLocalizedString(key, tableName: "Category", bundle: .module, comment: "")
        }
    }
}
