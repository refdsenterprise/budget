//
//  CategoryString.swift
//  
//
//  Created by Rafael Santos on 25/02/23.
//

import Foundation

// MARK: - Add Budget
public extension Strings {
    enum AddBudget {
        case navigationTitle
        case infoMonth
        case placeholderDescription
        case description
        case category
        case addNewCategory
        
        private var key: String {
            switch self {
            case .navigationTitle: return "addBudget.navigation.title"
            case .infoMonth: return "addBudget.infoMonth"
            case .placeholderDescription: return "addBudget.placeholder.description"
            case .category: return "addBudget.category"
            case .description: return "addBudget.description"
            case .addNewCategory: return "addBudget.addNewCategory"
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
        case noBudgetAdded
        
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
            case .noBudgetAdded: return "addCategory.noBudgetAdded"
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
        case mediumBudget
        case rowSpending(String)
        case rowTransactionsAmount(Int)
        case rowMedium
        case currentValue
        case edit
        case remove
        case alertCreateCategoryTitle
        case alertCreateCategoryDescription
        case alertButton
        case alertCreateBudgetTitle
        case alertCreateBudgetDescription
        
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
            case .mediumBudget: return "category.section.header.category.mediumBudget"
            case .rowSpending: return "category.row.spending"
            case .rowTransactionsAmount: return "category.row.transactionsAmount"
            case .rowMedium: return "category.row.medium"
            case .currentValue: return "currentValue"
            case .edit: return "edit"
            case .remove: return "remove"
            case .alertCreateCategoryTitle: return "category.alertCreateCategoryTitle"
            case .alertCreateCategoryDescription: return "category.alertCreateCategoryDescription"
            case .alertButton: return "category.alertButton"
            case .alertCreateBudgetTitle: return "category.alertCreateBudgetTitle"
            case .alertCreateBudgetDescription: return "category.alertCreateBudgetDescription"
            }
        }
        
        public var value: String {
            switch self {
            case .rowSpending(let percent): return String(format: NSLocalizedString(key, tableName: "Category", bundle: .module, comment: ""), percent)
            case .rowTransactionsAmount(let count): return String(format: NSLocalizedString(key, tableName: "Category", bundle: .module, comment: ""), count)
            default: return NSLocalizedString(key, tableName: "Category", bundle: .module, comment: "")
            }
        }
    }
}

// MARK: - General
public extension Strings {
    enum General {
        case save
        case budgetSave
        
        private var key: String {
            switch self {
            case .save: return "save.button"
            case .budgetSave: return "budget.save.button"
            }
        }
        
        public var value: String {
            NSLocalizedString(key, tableName: "Category", bundle: .module, comment: "")
        }
    }
}
