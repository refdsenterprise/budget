//
//  NotificationiOSView.swift
//  
//
//  Created by Rafael Santos on 03/04/23.
//

import SwiftUI
import RefdsUI
import Presentation

struct NotificationiOSView<Presenter: NotificationManagerPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        Group {
            switch presenter.viewState {
            case .unallowed: sectionUnallowedNotification
            case .hideOptions: sectionNotificationHideOptions
            case .showOptions: List { sectionNotificationShowOptions }
            }
        }
        .navigationTitle(presenter.string(.navigationTitle))
        .onReceive(SwiftUI.NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Task { await presenter.checkNotificationPermission() }
        }
    }
    
    private var sectionAllowNotification: some View {
        Section {
            Toggle(isOn: $presenter.isAllowNotification) {
                RefdsText(presenter.string(.allowNotification))
            }
            .toggleStyle(CheckBoxStyle())
        }
    }
    
    private var sectionUnallowedNotification: some View {
        VStack(alignment: .center, spacing: 30) {
            RefdsIcon(symbol: .bellBadgeFill, color: .accentColor, size: 70, renderingMode: .hierarchical)
            VStack(alignment: .center, spacing: 10) {
                RefdsText(presenter.string(.disableNotificationTitle), size: .large, weight: .bold, alignment: .center)
                RefdsText(presenter.string(.disableNotificationDescription), color: .secondary, alignment: .center)
            }
            Button {
                presenter.actionNotificationSettings()
            } label: {
                RefdsText(presenter.string(.changeNotificationPermission).uppercased(), size: .small, color: .white, weight: .bold)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(8)
            }

        }
        .padding()
    }
    
    private var sectionNotificationHideOptions: some View {
        VStack(alignment: .center, spacing: 30) {
            RefdsIcon(symbol: .bellAndWavesLeftAndRightFill, color: .accentColor, size: 70, renderingMode: .hierarchical)
            VStack(alignment: .center, spacing: 10) {
                RefdsText(presenter.string(.allowNotificationDescription), color: .secondary, alignment: .center)
            }
            Button {
                presenter.isAllowNotification.toggle()
            } label: {
                RefdsText(presenter.string(.activeNotifications).uppercased(), size: .small, color: .white, weight: .bold)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(8)
            }

        }
        .padding()
    }
    
    private var sectionNotificationShowOptions: some View {
        Group {
            sectionAllowNotification
            Section {
                ForEach(presenter.viewData.indices, id: \.self) { index in
                    rowNotificationOption(index: index)
                }
            } header: {
                RefdsText(presenter.string(.options), size: .extraSmall, color: .secondary)
            }
        }
    }
    
    private func rowNotificationOption(index: Int) -> some View {
        HStack(spacing: 15) {
            Image(systemName: presenter.viewData[index].icon)
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 22, weight: .bold))
            Toggle(isOn: $presenter.viewData[index].isOn) {
                VStack(alignment: .leading, spacing: 5) {
                    RefdsText(presenter.viewData[index].title.capitalized, size: .small, weight: .bold)
                    RefdsText(presenter.viewData[index].description, color: .secondary)
                }
            }
            .toggleStyle(CheckBoxStyle())
        }
    }
}
