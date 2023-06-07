//
//  CustomAppIconPresenter.swift
//  
//
//  Created by Rafael Santos on 02/06/23.
//

import Foundation
import SwiftUI
import RefdsUI
import Resource

public protocol CustomAppIconPresenterProtocol: ObservableObject {
    var iconSelection: ResourceImage.CustomAppIcon { get set }
    var alert: RefdsAlert.ViewData? { get set }
    func changeIcon()
}

public final class CustomAppIconPresenter: CustomAppIconPresenterProtocol {
    @AppStorage(.refdsString(.storage(.customAppIcon))) private var customAppIcon: String = "AppIcon"
    
    @Published public var alert: RefdsAlert.ViewData?
    @Published public var iconSelection: ResourceImage.CustomAppIcon = .default
    
    public init() {
        if let icon = ResourceImage.CustomAppIcon(rawValue: customAppIcon) {
            iconSelection = icon
        }
    }
    
    @MainActor public func changeIcon() {
        iconSelection.changeIcon {
            self.customAppIcon = self.iconSelection.rawValue
        } onError: {
            self.alert = .init(style: .inline(.critical, Strings.AppIcon.alertError.value))
        }
    }
}
