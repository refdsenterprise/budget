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
    var amountTransactions: Int { get }
    var amountCategories: Int { get }
    var amountBudgets: Int { get }
    
    var isPresentedPro: Bool { get set }
    
    func string(_ string: Strings.Settings) -> String
}

public final class SettingsPresenter: SettingsPresenterProtocol {
    public var router: SettingsRouter
    
    @Published public var isPresentedPro: Bool = false
    
    public var amountTransactions: Int {
        Storage.shared.transaction.getAllTransactions().count
    }
    
    public var amountCategories: Int {
        Storage.shared.category.getAllCategories().count
    }
    
    public var amountBudgets: Int {
        Storage.shared.category.getAllCategories().flatMap({ $0.budgets }).count
    }
    
    public init(router: SettingsRouter) {
        self.router = router
    }
    
    public func string(_ string: Strings.Settings) -> String {
        return string.value
    }
}
