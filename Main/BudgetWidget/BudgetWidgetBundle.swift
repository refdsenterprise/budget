//
//  BudgetWidgetBundle.swift
//  BudgetWidget
//
//  Created by Rafael Santos on 13/03/23.
//

import WidgetKit
import SwiftUI

@main
struct BudgetWidgetBundle: WidgetBundle {
    var body: some Widget {
        BudgetWidget()
        BudgetWidgetLiveActivity()
    }
}
