//
//  SettingsPresenter.swift
//  
//
//  Created by Rafael Santos on 27/03/23.
//

import SwiftUI
import Domain
import Data
import Resource

public protocol SettingsPresenterProtocol: ObservableObject {
    var router: SettingsRouter { get }
    var needShowModalPro: Bool { get set }
    
    func string(_ string: Strings.Settings) -> String
    func loadData()
}

public final class SettingsPresenter: SettingsPresenterProtocol {
    public var router: SettingsRouter
    @Published public var needShowModalPro: Bool = false
    
    public init(router: SettingsRouter) {
        self.router = router
        Task { await updateShowModalPro() }
    }
    
    public func loadData() {
        Task { await updateShowModalPro() }
    }
    
    public func string(_ string: Strings.Settings) -> String {
        return string.value
    }
    
    @MainActor private func updateShowModalPro() async {
        //needShowModalPro = !Worker.shared.settings.get().isPro
    }
}
