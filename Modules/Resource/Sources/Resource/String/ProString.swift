//
//  ProString.swift
//  
//
//  Created by Rafael Santos on 31/03/23.
//

import Foundation

public extension Strings {
    enum Pro {
        case navigationTitle
        case benefitsDescription
        case remaningTitle
        case remaningDescription
        case chartsTitle
        case chartsDescription
        case maxTransactionTitle
        case maxTransactionDescription
        case weekDayTitle
        case weekDayDescription
        case reportHeader
        case filterTitle
        case filterDescription
        case categoryTitle
        case categoryDescription
        case macOSTitle
        case macOSDescription
        case notificationTitle
        case notificationDescription
        case customizationTitle
        case customizationDescription
        case resourceHeader
        case acceptedTerms
        case appleInPurchaseDescription
        case beProButton(String)
        case readTermsButton
        
        private var key: String {
            switch self {
            case .navigationTitle: return "pro.navigationTitle"
            case .benefitsDescription: return "pro.benefitsDescription"
            case .remaningTitle: return "pro.remaningTitle"
            case .remaningDescription: return "pro.remaningDescription"
            case .chartsTitle: return "pro.chartsTitle"
            case .chartsDescription: return "pro.chartsDescription"
            case .maxTransactionTitle: return "pro.maxTransactionTitle"
            case .maxTransactionDescription: return "pro.maxTransactionDescription"
            case .weekDayTitle: return "pro.weekDayTitle"
            case .weekDayDescription: return "pro.weekDayDescription"
            case .reportHeader: return "pro.reportHeader"
            case .filterTitle: return "pro.filterTitle"
            case .filterDescription: return "pro.filterDescription"
            case .categoryTitle: return "pro.categoryTitle"
            case .categoryDescription: return "pro.categoryDescription"
            case .macOSTitle: return "pro.macOSTitle"
            case .macOSDescription: return "pro.macOSDescription"
            case .notificationTitle: return "pro.notificationTitle"
            case .notificationDescription: return "pro.notificationDescription"
            case .customizationTitle: return "pro.customizationTitle"
            case .customizationDescription: return "pro.customizationDescription"
            case .resourceHeader: return "pro.resourceHeader"
            case .acceptedTerms: return "pro.acceptedTerms"
            case .appleInPurchaseDescription: return "pro.appleInPurchaseDescription"
            case .beProButton(_): return "pro.beProButton"
            case .readTermsButton: return "pro.readTermsButton"
            }
        }
        
        public var value: String {
            switch self {
            case .beProButton(let value): return String(format: NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: ""), value)
            default: return NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: "")
            }
        }
    }
}
