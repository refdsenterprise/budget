//
//  CustomizationPresenter.swift
//  
//
//  Created by Rafael Santos on 09/04/23.
//

import SwiftUI
import Resource
import Domain
import Data

public protocol CustomizationPresenterProtocol: ObservableObject {
    var appearenceSelected: AppearenceItem { get set }
    
    func string(_ string: Strings.Customization) -> String
}

public final class CustomizationPresenter: CustomizationPresenterProtocol {
    @Published public var appearenceSelected: AppearenceItem = Storage.shared.settings.customization.appearence {
        didSet { Storage.shared.settings.customization.appearence = appearenceSelected }
    }
    
    public init() {}
    
    public func string(_ string: Strings.Customization) -> String {
        string.value
    }
}
