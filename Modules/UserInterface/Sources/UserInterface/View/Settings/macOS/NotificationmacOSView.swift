//
//  NotificationmacOSView.swift
//  
//
//  Created by Rafael Santos on 17/04/23.
//

import SwiftUI
import RefdsUI
import Presentation

struct NotificationmacOSView<Presenter: NotificationManagerPresenterProtocol>: View {
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        Group {
            switch presenter.viewState {
            case .unallowed: sectionUnallowedNotification
            case .hideOptions: sectionNotificationHideOptions
            case .showOptions:
                MacUIView(sections: [
                    .init(maxAmount: 1, content: {
                        sectionAllowNotification
                    }),
                    .init(content: {
                        sectionNotificationShowOptions
                    })
                ])
            }
        }
        .navigationTitle(presenter.string(.navigationTitle))
        .onReceive(SwiftUI.NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Task { await presenter.checkNotificationPermission() }
        }
    }
    
    private var sectionAllowNotification: some View {
        SectionGroup(headerTitle: presenter.string(.status)) {
            Group {
                Toggle(isOn: $presenter.isAllowNotification) {
                    RefdsText(presenter.string(.allowNotification))
                }
                .tint(.accentColor)
            }
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
        .frame(maxWidth: 450)
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
        .frame(maxWidth: 450)
    }
    
    private var sectionNotificationShowOptions: some View {
        Group {
            ForEach(presenter.viewData.indices, id: \.self) { index in
                GroupBox { rowNotificationOption(index: index) }
                    .listGroupBoxStyle()
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
            .tint(.accentColor)
        }
    }
}
