//
//  PeriodSelectionView.swift
//  
//
//  Created by Rafael Santos on 27/02/23.
//

import SwiftUI
import RefdsUI
import RefdsCore
import Resource

public struct PeriodSelectionView: View {
    @State private var isCollapsed: Bool = true
    @Binding private var date: Date
    private let dateFormat: String.DateFormat
    private var action: ((Date) -> Void)?
    
    public init(isCollapsed: Bool = true, date: Binding<Date>, dateFormat: String.DateFormat, action: ((Date) -> Void)? = nil) {
        self._isCollapsed = State(initialValue: isCollapsed)
        self._date = date
        self.dateFormat = dateFormat
        self.action = action
    }
    
    public var body: some View {
        Section {
            #if os(iOS)
            Button {
                withAnimation {
                    isCollapsed.toggle()
                }
            } label: {
                HStack(spacing: 15) {
                    RefdsText(Strings.UserInterface.periodTitle.value)
                    Spacer()
                    RefdsText(date.asString(withDateFormat: dateFormat).capitalized, color: .secondary)
                    RefdsIcon(symbol: .chevronRight, color: .accentColor, size: 16, weight: .medium, renderingMode: .hierarchical)
                        .rotationEffect(isCollapsed ? .degrees(0) : .degrees(90))
                }
            }
            #else
            HStack(spacing: 15) {
                RefdsText(Strings.UserInterface.periodTitle.value)
                Spacer()
                RefdsText(date.asString(withDateFormat: dateFormat).capitalized, color: .secondary)
                RefdsIcon(symbol: .chevronRight, color: .accentColor, size: 16, weight: .medium, renderingMode: .hierarchical)
                    .rotationEffect(isCollapsed ? .degrees(0) : .degrees(90))
            }
            .onTapGesture {
                withAnimation {
                    isCollapsed.toggle()
                }
            }
            #endif
            if !isCollapsed {
                DatePicker(selection: Binding(get: { date }, set: { date = $0; action?($0) }), displayedComponents: .date) {
                    EmptyView()
                }
                .datePickerStyle(.graphical)
                .onChange(of: date) { _ in
                    withAnimation {
                        isCollapsed.toggle()
                    }
                }
            }
        }
    }
}

struct PeriodSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PeriodSelectionView(date: .constant(.current), dateFormat: .dayMonthYear)
    }
}
