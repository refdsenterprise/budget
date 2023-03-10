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
    private var device: Device
    @Environment(\.dismiss) var dismiss
    
    public init(device: Device, presenter: Presenter) {
        self.device = device
        _presenter = StateObject(wrappedValue: presenter)
    }
    
    public var body: some View {
        if device == .macOS {
            AddCategorymacOSView(presenter: presenter)
        } else {
            AddCategoryiOSView(presenter: presenter)
        }
    }
}

struct AddCategoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    AddCategoryScreen(device: .iOS, presenter: AddCategoryPresenter.instance)
                }
                .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            }
        }
        
        Group {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    AddCategoryScreen(device: .macOS, presenter: AddCategoryPresenter.instance)
                }
                .previewDevice(PreviewDevice(rawValue: "iPad Air (5th generation)"))
            }
        }
    }
}
