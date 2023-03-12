//
//  Double+Extensions.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import Foundation
import Resource

public extension Double {
    var currency: String {
        self.formatted(.currency(code: Strings.UserInterface.currencyCode.value))
    }
}
