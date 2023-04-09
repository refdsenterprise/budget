//
//  NotificationManagerPresenter.swift
//  
//
//  Created by Rafael Santos on 06/04/23.
//

import SwiftUI
import RefdsUI
import Domain
import Data
import Resource

public protocol NotificationManagerPresenterProtocol: ObservableObject {
    var viewState: NotificationManagerViewState { get set }
    var viewData: [NotificationManagerViewData] { get set }
    var isAllowNotification: Bool { get set }
    
    func string(_ string: Strings.NotificationManager) -> String
    func actionNotificationSettings()
    func checkNotificationPermission()
}

public final class NotificationManagerPresenter: NotificationManagerPresenterProtocol {
    @Published public var viewState: NotificationManagerViewState = .showOptions
    @Published public var viewData: [NotificationManagerViewData] = [] {
        didSet { viewDataHandler() }
    }
    
    @Published public var isAllowNotification: Bool = true {
        didSet { isAllowNotificationHandler() }
    }
    
    private var notificationManager: NotificationManagerEntity {
        didSet { notificationManager.save() }
    }
    
    public init() {
        self.notificationManager = BudgetDatabase.shared.get(on: .notificationManager) ?? .init()
        self.viewData = getViewData(notificationManager: notificationManager)
    }
    
    private func getViewData(notificationManager: NotificationManagerEntity) -> [NotificationManagerViewData] {
        isAllowNotification = notificationManager.notificationsIsOn
        checkNotificationPermission()
        
        var viewData: [NotificationManagerViewData] = []
        
        viewData.append(.init(
            isOn: notificationManager.remiderIsOn,
            title: string(.remiderTitle),
            icon: RefdsIconSymbol.calendarBadgeClock.rawValue,
            description: string(.remiderDescription),
            type: .remider
        ))
        
        viewData.append(.init(
            isOn: notificationManager.warningIsOn,
            title: string(.warningTitle),
            icon: RefdsIconSymbol.exclamationmarkTriangleFill.rawValue,
            description: string(.warningDescription),
            type: .warning
        ))
        
        viewData.append(.init(
            isOn: notificationManager.breakingIsOn,
            title: string(.breakingTitle),
            icon: RefdsIconSymbol.exclamationmarkOctagonFill.rawValue,
            description: string(.breakingDescription),
            type: .breaking
        ))
        
        return viewData
    }
    
    private func isAllowNotificationHandler() {
        viewState = isAllowNotification ? .showOptions : .hideOptions
        notificationManager.notificationsIsOn = isAllowNotification
    }
    
    private func viewDataHandler() {
        viewData.forEach { viewData in
            switch viewData.type {
            case .remider: notificationManager.remiderIsOn = viewData.isOn
            case .warning: notificationManager.warningIsOn = viewData.isOn
            case .breaking: notificationManager.breakingIsOn = viewData.isOn
            }
        }
    }
    
    public func string(_ string: Strings.NotificationManager) -> String {
        string.value
    }
    
    public func actionNotificationSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    public func checkNotificationPermission() {
        NotificationCenter.shared.notificationSettings {
            self.viewState = !$0 ? .unallowed : self.isAllowNotification ? .showOptions : .hideOptions
        }
    }
}
