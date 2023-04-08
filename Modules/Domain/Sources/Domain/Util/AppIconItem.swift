//
//  AppIconItem.swift
//  
//
//  Created by Rafael Santos on 30/03/23.
//

import SwiftUI
import RefdsCore

public struct AppIconItem: DomainModel {
    public var icon: String
    public var color: Color
    
    public init(icon: String, color: Color) {
        self.icon = icon
        self.color = color
    }
}
