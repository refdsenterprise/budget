//
//  AddCategoryViewData.swift
//  
//
//  Created by Rafael Santos on 14/04/23.
//

import SwiftUI
import RefdsUI
import RefdsCore

public struct AddCategoryViewData {
    public var id: UUID = .init()
    public var name: String = ""
    public var color: Color = .accentColor
    public var icon: RefdsIconSymbol = .dollarsign
    public var budgets: [AddBudgetViewData] = []
}
