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
            case .navigationTitle: return "navigationTitle"
            case .benefitsDescription: return "benefitsDescription"
            case .remaningTitle: return "remaningTitle"
            case .remaningDescription: return "remaningDescription"
            case .chartsTitle: return "chartsTitle"
            case .chartsDescription: return "chartsDescription"
            case .maxTransactionTitle: return "maxTransactionTitle"
            case .maxTransactionDescription: return "maxTransactionDescription"
            case .weekDayTitle: return "weekDayTitle"
            case .weekDayDescription: return "weekDayDescription"
            case .reportHeader: return "reportHeader"
            case .filterTitle: return "filterTitle"
            case .filterDescription: return "filterDescription"
            case .categoryTitle: return "categoryTitle"
            case .categoryDescription: return "categoryDescription"
            case .macOSTitle: return "macOSTitle"
            case .macOSDescription: return "macOSDescription"
            case .notificationTitle: return "notificationTitle"
            case .notificationDescription: return "notificationDescription"
            case .customizationTitle: return "customizationTitle"
            case .customizationDescription: return "customizationDescription"
            case .resourceHeader: return "resourceHeader"
            case .acceptedTerms: return "acceptedTerms"
            case .appleInPurchaseDescription: return "appleInPurchaseDescription"
            case .beProButton(_): return "beProButton"
            case .readTermsButton: return "readTermsButton"
            }
        }
        
        public var value: String {
            switch self {
            case .beProButton(let value): return String(format: NSLocalizedString(key, tableName: "Pro", bundle: .module, comment: ""), value)
            default: return NSLocalizedString(key, tableName: "Pro", bundle: .module, comment: "")
            }
        }
    }
}
