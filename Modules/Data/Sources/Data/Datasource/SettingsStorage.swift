//
//  SettingsStorage.swift
//  
//
//  Created by Rafael Santos on 30/03/23.
//

import SwiftUI
import Domain

public final class SettingsStorage {
    public static let shared = SettingsStorage()
    
    private var appIcon: AppIconItem? {
        get { BudgetDatabase.shared.get(on: .appIcon) }
        set { BudgetDatabase.shared.set(on: .appIcon, value: newValue) }
    }
}
