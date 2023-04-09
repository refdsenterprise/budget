//
//  CustomizationEntity.swift
//  
//
//  Created by Rafael Santos on 09/04/23.
//

import Foundation
import SwiftUI
import RefdsCore

public struct CustomizationEntity: DomainModel {
    public var themeColor: Color
    public var appearence: AppearenceItem
    
    public init(themeColor: Color, appearence: AppearenceItem) {
        self.themeColor = themeColor
        self.appearence = appearence
    }
}
