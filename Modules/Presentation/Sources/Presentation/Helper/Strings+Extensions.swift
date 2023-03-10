//
//  Strings+Extensions.swift
//  
//
//  Created by Rafael Santos on 24/02/23.
//

import Foundation

public extension StringProtocol {
    var stripingDiacritics: String {
        applyingTransform(.stripDiacritics, reverse: false)!
    }
}
