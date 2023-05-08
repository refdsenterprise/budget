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
    private var isPresentedAddTransaction: Bool
    @StateObject private var presenter: Presenter
    
    public init(presenter: Presenter, isPresentedAddTransaction: Bool = false) {
        _presenter = StateObject(wrappedValue: presenter)
        self.isPresentedAddTransaction = isPresentedAddTransaction
    }
    
    public var body: some View {
        if Device.current == .macOS {
            TransactionmacOSView<Presenter>()
                .environmentObject(presenter)
                .onAppear {
                    if isPresentedAddTransaction { presenter.isPresentedAddTransaction.toggle() }
                }
        } else {
            TransactioniOSView<Presenter>()
                .environmentObject(presenter)
                .onAppear {
                    if isPresentedAddTransaction { presenter.isPresentedAddTransaction.toggle() }
                }
        }
    }
}
