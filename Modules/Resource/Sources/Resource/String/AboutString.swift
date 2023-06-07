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
            case .navigationTitle: return "about.navigationTitle"
            case .applicationDescription: return "about.applicationDescription"
            case .optionWebsite: return "about.optionWebsite"
            case .optionGithub: return "about.optionGithub"
            case .optionWriteReview: return "about.optionWriteReview"
            case .optionShare: return "about.optionShare"
            case .applicationName: return "about.applicationName"
            case .applicationAuthor: return "about.applicationAuthor"
            }
        }
        
        public var value: String {
            NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: "")
        }
    }
}
