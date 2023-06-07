//
//  TransactionCardView.swift
//  
//
//  Created by Rafael Santos on 23/05/23.
//

import SwiftUI
import RefdsUI
import Presentation

public struct TransactionCardView: View {
    private let transaction: TransactionViewData.Transaction
    @State private var isSelected: Bool = false
    
    public init(transaction: TransactionViewData.Transaction) {
        self.transaction = transaction
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 15) {
                RefdsButton {
                    withAnimation { isSelected.toggle() }
                } label: { categoryView }
                .padding(.all, 5)
                .background(transaction.categoryColor.opacity(0.2))
                .cornerRadius(8)
                RefdsText(transaction.amount.currency, style: .title3, weight: .bold, alignment: .leading, lineLimit: 1)
                Spacer()
                RefdsText(transaction.date.asString(withDateFormat: .custom("HH:mm")))
            }
            .padding(.vertical, 5)
            HStack {
                RefdsText(transaction.description, color: .secondary)
                Spacer()
            }
            Spacer(minLength: 0)
        }
    }
    
    @ViewBuilder
    private var categoryView: some View {
        HStack {
            RefdsIcon(symbol: transaction.categoryIcon, color: transaction.categoryColor, size: 12, weight: .medium, renderingMode: .hierarchical)
            if isSelected {
                RefdsText(transaction.categoryName.uppercased(), style: .caption2, color: transaction.categoryColor, weight: .bold)
            }
        }.frame(width: isSelected ? nil : 18, height: 18)
    }
}

struct TransactionCardView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ForEach(0...10, id: \.self) { index in
                TransactionCardView(transaction: .init(id: .init(), date: .current, description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", categoryName: "Lorem Ipsum", categoryColor: .random, amount: .random(in: 0...900), categoryIcon: .theatermasks))
            }
        }
    }
}
