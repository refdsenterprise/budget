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
    func checkNotificationPermission() async
}

public final class NotificationManagerPresenter: NotificationManagerPresenterProtocol {
    @Published public var viewState: NotificationManagerViewState = .showOptions
    @Published public var viewData: [NotificationManagerViewData] = [] {
        didSet { viewDataHandler() }
    }
    
    @Published public var isAllowNotification: Bool = true {
        didSet { isAllowNotificationHandler() }
    }
    
    public init() {
        Task { await setViewData() }
    }
    
    @MainActor private func setViewData() async {
        let settings = Worker.shared.settings.get()
        await checkNotificationPermission()
        isAllowNotification = settings.notifications
        
        var viewData: [NotificationManagerViewData] = []
        
        viewData.append(.init(
            isOn: settings.warningNotification,
            title: string(.warningTitle),
            icon: RefdsIconSymbol.exclamationmarkTriangleFill.rawValue,
            description: string(.warningDescription),
            type: .warning
        ))
        
        viewData.append(.init(
            isOn: settings.breakingNotification,
            title: string(.breakingTitle),
            icon: RefdsIconSymbol.exclamationmarkOctagonFill.rawValue,
            description: string(.breakingDescription),
            type: .breaking
        ))
        
        viewData.append(.init(
            isOn: settings.reminderNotification,
            title: string(.remiderTitle),
            icon: RefdsIconSymbol.calendarBadgeClock.rawValue,
            description: string(.remiderDescription),
            type: .remider
        ))
        
        self.viewData = viewData
    }
    
    private func isAllowNotificationHandler() {
        viewState = isAllowNotification ? .showOptions : .hideOptions
        try? Worker.shared.settings.add(
            notifications: isAllowNotification,
            reminderNotification: isAllowNotification,
            warningNotification: isAllowNotification,
            breakingNotification: isAllowNotification
        )
    }
    
    private func viewDataHandler() {
        viewData.forEach { viewData in
            switch viewData.type {
            case .remider: try? Worker.shared.settings.add(reminderNotification: viewData.isOn)
            case .warning: try? Worker.shared.settings.add(warningNotification: viewData.isOn)
            case .breaking: try? Worker.shared.settings.add(breakingNotification: viewData.isOn)
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
    
    @MainActor public func checkNotificationPermission() async {
        await withCheckedContinuation({ continuation in
            NotificationCenter.shared.notificationSettings { allowed in
                DispatchQueue.main.async {
                    self.viewState = !allowed ? .unallowed : self.isAllowNotification ? .showOptions : .hideOptions
                    continuation.resume()
                }
            }
        })
    }
}
