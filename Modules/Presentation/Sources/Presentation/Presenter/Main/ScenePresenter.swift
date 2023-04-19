//
//  ScenePresenter.swift
//  
//
//  Created by Rafael Santos on 18/04/23.
//

import SwiftUI
import Domain
import Resource

public protocol ScenePresenterProtocol: ObservableObject {
    var router: SceneRouter { get set }
    var tabItems: [TabItem] { get }
    var creationItems: [CreationItem] { get }
    var tabItemSelection: TabItem { get set }
    
    func string(_ string: Strings.Scene) -> String
}

public final class ScenePresenter: ScenePresenterProtocol {
    @Published public var router: SceneRouter
    @Published public var tabItemSelection: TabItem = .home
    
    public var tabItems: [TabItem] { TabItem.allCases }
    public var creationItems: [CreationItem] { CreationItem.allCases }
    
    public init(router: SceneRouter) {
        self.router = router
    }
    
    public func string(_ string: Strings.Scene) -> String {
        string.value
    }
}
