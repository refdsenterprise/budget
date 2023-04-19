//
//  Mock.swift
//  
//
//  Created by Rafael Santos on 12/04/23.
//

import Foundation

public enum Mock {
    case categories
    case transactions
    
    public var path: String? {
        switch self {
        case .categories: return Bundle.main.path(forResource: "categories", ofType: "json")
        case .transactions: return Bundle.main.path(forResource: "transactions", ofType: "json")
        }
    }
    
    public var data: Data? {
        guard let path = path else { return nil }
        let url = URL(fileURLWithPath: path)
        return try? Data(contentsOf: url)
    }
}

