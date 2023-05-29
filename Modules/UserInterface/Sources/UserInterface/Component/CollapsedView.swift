//
//  CollapsedView.swift
//  Budget
//
//  Created by Rafael Santos on 22/02/23.
//

import SwiftUI
import RefdsUI

public struct CollapsedView: View {
    @State private var showOptions = false
    private var title: String? = nil
    private var description: String? = nil
    private var row: (() -> any View)? = nil
    private var content: () -> any View

    public init(showOptions: Bool = false, title: String, description: String? = nil, content: @escaping () -> any View) {
        self.showOptions = showOptions
        self.title = title
        self.description = description
        self.content = content
    }
    
    public init(showOptions: Bool = false, row: @escaping () -> any View, content: @escaping () -> any View) {
        self.showOptions = showOptions
        self.row = row
        self.content = content
    }
    
    public var body: some View {
        #if os(iOS)
        Button {
            Application.shared.endEditing()
            withAnimation {
                showOptions.toggle()
            }
        } label: {
            if let title = title {
                rowView(title: title)
            } else if let row = row {
                rowView(row: row)
            }
        }
        #else
        Group {
            if let title = title {
                rowView(title: title)
            } else if let row = row {
                rowView(row: row)
            }
        }
        .onTapGesture {
            Application.shared.endEditing()
            withAnimation {
                showOptions.toggle()
            }
        }
        #endif
        if showOptions {
            AnyView(content())
        }
    }
    
    private func rowView(row: () -> any View) -> some View {
        Section {
            HStack(spacing: 7) {
                AnyView(row())
                Spacer(minLength: 0)
                RefdsIcon(symbol: .chevronRight, color: .accentColor, size: 16, weight: .medium, renderingMode: .hierarchical)
                    .rotationEffect(showOptions ? .degrees(90) : .degrees(0))
            }
        }
    }
    
    private func rowView(title: String) -> some View {
        Section {
            HStack(spacing: 15) {
                RefdsText(title)
                Spacer()
                if let description = description {
                    RefdsText(description, color: .secondary)
                }
                RefdsIcon(symbol: .chevronRight, color: .accentColor, size: 16, weight: .medium, renderingMode: .hierarchical)
                    .rotationEffect(showOptions ? .degrees(90) : .degrees(0))
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
                    RefdsTag("aplied", size: .custom(14), color: .yellow, lineLimit: 1)
                }
            }
        }
    }
}
