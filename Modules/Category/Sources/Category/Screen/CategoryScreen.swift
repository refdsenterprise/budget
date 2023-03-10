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
    private let device: Device
    private let transactionScene: ((CategoryEntity, Date) -> any View)?
    
    public init(device: Device, presenter: Presenter, transactionScene: ((CategoryEntity, Date) -> any View)? = nil) {
        self.device = device
        _presenter = StateObject(wrappedValue: presenter)
        self.transactionScene = transactionScene
    }
    
    public var body: some View {
        if device == .macOS {
            CategorymacOSView(presenter: presenter, transactionScene: transactionScene)
        } else {
            CategoryiOSView(presenter: presenter, transactionScene: transactionScene)
        }
    }
}

struct CategoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    CategoryScreen(device: .iOS, presenter: CategoryPresenter.instance)
                }
                .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            }
        }
        
        Group {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    CategoryScreen(device: .macOS, presenter: CategoryPresenter.instance)
                }
                .previewDevice(PreviewDevice(rawValue: "iPad Air (5th generation)"))
            }
        }
    }
}
