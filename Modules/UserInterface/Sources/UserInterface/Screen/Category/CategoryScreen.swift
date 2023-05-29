//
//  CategoryScreen.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI
import Presentation

public struct CategoryScreen<Presenter: CategoryPresenterProtocol>: View {
    @EnvironmentObject private var appConfigurator: AppConfiguration
    @StateObject private var presenter: Presenter
    
    public init(presenter: Presenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        if Device.current == .macOS {
            CategorymacOSView<Presenter>()
                .environmentObject(presenter)
                .onChange(of: appConfigurator.isPro) { _ in presenter.loadData() }
        } else {
            #if os(iOS)
            CategoryiOSView<Presenter>()
                .environmentObject(presenter)
                .onChange(of: appConfigurator.isPro) { _ in presenter.loadData() }
            #endif
        }
    }
}
