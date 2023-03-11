//
//  AddCategoryScreen.swift
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

public struct AddCategoryScreen<Presenter: AddCategoryPresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    @Environment(\.dismiss) var dismiss
    
    public init(presenter: Presenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        if Device.current == .macOS {
            AddCategorymacOSView<Presenter>()
                .environmentObject(presenter)
        } else {
            AddCategoryiOSView<Presenter>()
                .environmentObject(presenter)
        }
    }
}
