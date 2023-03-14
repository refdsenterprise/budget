//
//  BudgetAlertView.swift
//  
//
//  Created by Rafael Santos on 10/03/23.
//

import SwiftUI
import RefdsUI
import Domain
import Resource

public struct BudgetAlertView: View {
    @Binding private var alert: BudgetAlert
    
    public init(alert: Binding<BudgetAlert>) {
        self._alert = alert
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 10) {
            if let icon = alert.icon {
                RefdsIcon(symbol: icon, size: 40, renderingMode: .multicolor)
            }
            VStack(alignment: .center, spacing: 5) {
                RefdsText(alert.title, size: .large, weight: .bold, alignment: .center)
                if let message = alert.message {
                    RefdsText(message, color: .secondary, alignment: .center)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct BudgetAlertView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetAlertView(alert: .constant(.init()))
    }
}
