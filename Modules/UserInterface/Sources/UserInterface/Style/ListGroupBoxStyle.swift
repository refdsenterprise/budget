//
//  ListGroupBoxStyle.swift
//  
//
//  Created by Rafael Santos on 09/03/23.
//

import SwiftUI

public struct ListGroupBoxStyle: GroupBoxStyle {
    @Environment(\.colorScheme) var colorScheme
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(colorScheme == .light ? .white : Color(uiColor: .secondarySystemBackground))
            )
    }
}

extension View {
    public func listGroupBoxStyle() -> some View {
        self.groupBoxStyle(ListGroupBoxStyle())
    }
}
