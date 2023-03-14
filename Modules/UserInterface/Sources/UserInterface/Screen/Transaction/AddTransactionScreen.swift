//
//  AddTransactionScreen.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI
import Presentation

public struct AddTransactionScreen<Presenter: AddTransactionPresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    
    public init(presenter: Presenter) {
        self._presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        if Device.current == .macOS {
            AddTransactionmacOSView<Presenter>()
                .environmentObject(presenter)
        } else {
            AddTransactioniOSView<Presenter>()
                .environmentObject(presenter)
        }
    }
}
