//
//  MacUIView.swift
//  
//
//  Created by Rafael Santos on 09/03/23.
//

import SwiftUI

public struct MacUIView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    private let maxAmount: Int?
    private let content: () -> Content
    
    public init(maxAmount: Int? = nil, content: @escaping () -> Content) {
        self.maxAmount = maxAmount
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: .columns(width: proxy.size.width, maxAmount: maxAmount), content: content)
                    .padding()
            }
            .background(colorScheme == .light ? Color(hex: "F2F2F7") : Color(uiColor: .systemBackground))
        }
    }
}

struct MacUIView_Previews: PreviewProvider {
    static var previews: some View {
        MacUIView {
            ForEach(0 ..< 100, id: \.self) { index in
                GroupBox {
                    Text("\(index)")
                }
            }
        }
    }
}
