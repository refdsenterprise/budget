//
//  TransactionScreen.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI
import Presentation

public struct TransactionScreen<Presenter: TransactionPresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    
    public init(presenter: Presenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        if Device.current == .macOS {
            TransactionmacOSView<Presenter>()
                .environmentObject(presenter)
        } else {
            #if os(iOS)
            TransactioniOSView<Presenter>()
                .environmentObject(presenter)
            #endif
        }
    }
}
