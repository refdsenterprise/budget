//
//  MacUIView.swift
//  
//
//  Created by Rafael Santos on 09/03/23.
//

import SwiftUI

public struct MacUISection {
    public let maxAmount: Int?
    public let content: () -> any View
    
    public init(maxAmount: Int? = nil, content: @escaping () -> any View) {
        self.maxAmount = maxAmount
        self.content = content
    }
}

public struct MacUIView: View {
    @Environment(\.colorScheme) var colorScheme
    private var sections: [MacUISection]
    
    public init(sections: [MacUISection] = []) {
        self.sections = sections
    }
    
    public init(maxAmount: Int? = nil, content: @escaping () -> any View) {
        self.sections = [.init(maxAmount: maxAmount, content: content)]
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ScrollView {
                ForEach(sections.indices, id: \.self) { index in
                    let section = sections[index]
                    LazyVGrid(columns: .columns(width: proxy.size.width, maxAmount: section.maxAmount), content: { AnyView(section.content()) })
                        .padding()
                }
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
