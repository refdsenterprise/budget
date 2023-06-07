//
//  CustomAppIconScreen.swift
//  
//
//  Created by Rafael Santos on 02/06/23.
//

import SwiftUI
import Presentation

public struct CustomAppIconScreen<Presenter: CustomAppIconPresenterProtocol>: View {
    @StateObject private var presenter: Presenter
    
    public init(presenter: Presenter) {
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        CustomAppIconView<Presenter>()
            .environmentObject(presenter)
    }
}
