//
//  ListGroupBoxStyle.swift
//  
//
//  Created by Rafael Santos on 09/03/23.
//

import SwiftUI

public struct ListGroupBoxStyle: GroupBoxStyle {
    @Environment(\.colorScheme) var colorScheme
    private let isButton: Bool
    
    public init(isButton: Bool = false) {
        self.isButton = isButton
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        Group {
            if isButton {
                HStack {
                    configuration.content
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
            } else {
                configuration.content
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(colorScheme == .light ? .white : Color(uiColor: .secondarySystemBackground))
        )
    }
}

extension View {
    public func listGroupBoxStyle(isButton: Bool = false) -> some View {
        self.groupBoxStyle(ListGroupBoxStyle(isButton: isButton))
    }
}
