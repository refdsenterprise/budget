//
//  Strings.swift
//  
//
//  Created by Rafael Santos on 27/02/23.
//

import Foundation

public struct Strings { }

// MARK: - User Interface
public extension Strings {
    enum UserInterface {
        case periodTitle
        
        private var key: String {
            switch self {
            case .periodTitle: return "component.periodSelection.title"
            }
        }
        
        public var value: String {
            NSLocalizedString(key, tableName: "UserInterface", bundle: .module, comment: "")
        }
    }
}
