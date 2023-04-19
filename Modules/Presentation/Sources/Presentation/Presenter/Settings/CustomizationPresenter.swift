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
    var themeColor: Color { get set }
    
    func string(_ string: Strings.Customization) -> String
}

public final class CustomizationPresenter: CustomizationPresenterProtocol {
    @Published public var themeColor: Color = Color(hex: Worker.shared.settings.get().theme) {
        didSet { try? Worker.shared.settings.add(theme: themeColor.toHex()) }
    }
    
    @Published public var appearenceSelected: AppearenceItem = AppearenceItem(rawValue: Worker.shared.settings.get().appearence) ?? .automatic {
        didSet { try? Worker.shared.settings.add(appearence: appearenceSelected.rawValue) }
    }
    
    public init() {}
    
    public func string(_ string: Strings.Customization) -> String {
        string.value
    }
}
