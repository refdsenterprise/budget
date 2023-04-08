//
//  File.swift
//  
//
//  Created by Rafael Santos on 24/02/23.
//

import Foundation
import SwiftUI
import Domain
import RefdsUI
import Resource

public extension View {
    func budgetAlert(_ alert: Binding<BudgetAlert>) -> some View {
        self.refdsAlert(isPresented: alert.isPresented) {
            BudgetAlertView(alert: alert)
        } actions: {
            Button(role: .cancel, action: {}, label: {
                RefdsText(Strings.UserInterface.ok.value, size: .small, weight: .bold)
            })
        }
    }
    
    func navigation<C>(isPresented: Binding<Bool>, destination: () -> C) -> some View where C: View {
        self.background(
            NavigationLink(
                destination: destination(),
                isActive: isPresented
            ) { EmptyView() }.hidden()
        )
    }
    
    func share(item: Binding<ShareItem>) -> some View {
        self.sheet(isPresented: item.isPresented) {
            if let url = item.url.wrappedValue {
                if #available(iOS 16.0, *) {
                    ShareView(itemsToShare: [url])
                        .presentationDetents([.medium, .large])
                } else {
                    ShareView(itemsToShare: [url])
                }
            }
        }
    }
    
    func browser(item: Binding<ShareItem>) -> some View {
        self.sheet(isPresented: item.isPresented) {
            if let url = item.url.wrappedValue {
                if #available(iOS 16.0, *) {
                    SafariView(url: url)
                        .presentationDetents([.large])
                } else {
                    SafariView(url: url)
                }
            }
        }
    }
}
