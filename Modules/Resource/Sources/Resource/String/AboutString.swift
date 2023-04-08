//
//  AboutString.swift
//  
//
//  Created by Rafael Santos on 30/03/23.
//

import Foundation

public extension Strings {
    enum About {
        case navigationTitle
        case applicationDescription
        case optionWebsite
        case optionGithub
        case optionWriteReview
        case optionShare
        case applicationName
        case applicationAuthor
        
        private var key: String {
            switch self {
            case .navigationTitle: return "navigationTitle"
            case .applicationDescription: return "applicationDescription"
            case .optionWebsite: return "optionWebsite"
            case .optionGithub: return "optionGithub"
            case .optionWriteReview: return "optionWriteReview"
            case .optionShare: return "optionShare"
            case .applicationName: return "applicationName"
            case .applicationAuthor: return "applicationAuthor"
            }
        }
        
        public var value: String {
            NSLocalizedString(key, tableName: "About", bundle: .module, comment: "")
        }
    }
}
