//
//  SectionGroup.swift
//  
//
//  Created by Rafael Santos on 09/03/23.
//

import SwiftUI
import RefdsUI

public struct SectionGroup<Content: View>: View {
    private var headerTitle: String?
    private var header: (() -> any View)?
    private let content: () -> Content
    
    public init(headerTitle: String? = nil, header: (() -> any View)? = nil, content: @escaping () -> Content) {
        self.headerTitle = headerTitle
        self.header = header
        self.content = content
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            if let headerTitle = headerTitle {
                RefdsText(headerTitle.uppercased(), size: .extraSmall, color: .secondary)
            }
            
            GroupBox {
                content()
                    .padding(.vertical, -4)
                    .frame(maxWidth: .infinity)
            }
            .listGroupBoxStyle()
        }
        .frame(maxWidth: .infinity)
    }
}

struct SectionGroup_Previews: PreviewProvider {
    static var previews: some View {
        SectionGroup(headerTitle: "HelloWord") {
            HStack {
                RefdsIcon(symbol: .infinity)
                RefdsText("Infinity icon")
                Spacer()
                RefdsText("Detailed", color: .secondary)
            }
        }
    }
}
