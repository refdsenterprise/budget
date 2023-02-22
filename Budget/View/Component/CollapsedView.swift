//
//  CollapsedView.swift
//  Budget
//
//  Created by Rafael Santos on 22/02/23.
//

import SwiftUI
import RefdsUI

struct CollapsedView: View {
    @State private var showOptions = false
    let title: String
    let content: () -> any View
    
    init(showOptions: Bool = false, title: String, content: @escaping () -> any View) {
        self.showOptions = showOptions
        self.title = title
        self.content = content
    }
    
    var body: some View {
        Section {
            Button {
                withAnimation {
                    showOptions.toggle()
                }
            } label: {
                HStack {
                    RefdsText(title)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .medium))
                        .rotationEffect(showOptions ? .degrees(90) : .degrees(0))
                }
            }
            if showOptions {
                AnyView(content())
            }
        }
    }
}

struct CollapsedView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CollapsedView(title: "Opções") {
                HStack {
                    RefdsText("Filtro")
                    Spacer()
                    RefdsTag("aplied", size: .custom(14), color: .yellow, family: .moderatMono, lineLimit: 1)
                }
            }
        }
    }
}
