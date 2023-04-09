//
//  AppearenceItem.swift
//  
//
//  Created by Rafael Santos on 09/04/23.
//

import SwiftUI
import RefdsUI
import RefdsCore
import Resource

public enum AppearenceItem: CaseIterable, DomainModel {
    case automatic
    case dark
    case light
    
    public var description: String {
        switch self {
        case .automatic: return Strings.Customization.auto.value
        case .dark: return Strings.Customization.dark.value
        case .light: return Strings.Customization.light.value
        }
    }
    
    public var colorScheme: ColorScheme? {
        switch self {
        case .automatic: return nil
        case .dark: return .dark
        case .light: return .light
        }
    }
    
    public var icon: RefdsIconSymbol {
        switch self {
        case .automatic: return .gearCircle
        case .dark: return .moonStarsFill
        case .light: return .sunMaxFill
        }
    }
}
