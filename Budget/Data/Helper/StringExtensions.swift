//
//  StringExtensions.swift
//  Budget
//
//  Created by Rafael Santos on 22/02/23.
//

import Foundation

extension StringProtocol {
    var stripingDiacritics: String {
        applyingTransform(.stripDiacritics, reverse: false)!
    }
}
