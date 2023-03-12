//
//  AppConfiguration.swift
//  
//
//  Created by Rafael Santos on 11/03/23.
//

import Foundation
import SwiftUI

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue: Color = .accentColor
}

public extension EnvironmentValues {
    var appTheme: Color {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}

public final class AppConfiguration: ObservableObject {
    public static let shared = AppConfiguration()
    
    @Published public var themeColor: Color = .accentColor
}
