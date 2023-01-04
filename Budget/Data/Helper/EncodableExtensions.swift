//
//  EncodableExtensions.swift
//  Budget
//
//  Created by Rafael Santos on 04/01/23.
//

import Foundation

extension Encodable {
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
