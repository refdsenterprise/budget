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
    func budgetAlert(_ alert: Binding<AlertItem>) -> some View {
        self.alert(isPresented: alert.isPresented) {
            alert.wrappedValue.alert
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
                        .presentationDetents([.medium])
                } else {
                    ShareView(itemsToShare: [url])
                }
            }
        }
    }
}
