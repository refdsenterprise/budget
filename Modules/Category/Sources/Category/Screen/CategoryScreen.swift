//
//  CategoryScreen.swift
//  Budget
//
//  Created by Rafael Santos on 30/12/22.
//

import SwiftUI
import RefdsUI
import Domain
import Presentation
import UserInterface
import Resource

public struct CategoryScreen<Presenter: CategoryPresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    
    public init(presenter: Presenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        if Device.current == .macOS {
            CategorymacOSView<Presenter>()
                .environmentObject(presenter)
        } else {
            CategoryiOSView<Presenter>()
                .environmentObject(presenter)
        }
    }
}
