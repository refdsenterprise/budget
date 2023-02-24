//
//  Encodable+Extensions.swift
//  
//
//  Created by Rafael Santos on 24/02/23.
//

import Foundation

public extension Encodable {
    var asString: String {
        guard let data = self.asData, let string = String(data: data, encoding: .utf8) else { return "" }
        return string
    }
    
    var asData: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try? encoder.encode(self)
    }
}
