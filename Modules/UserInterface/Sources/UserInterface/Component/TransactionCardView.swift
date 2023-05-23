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
    
    public init(transaction: TransactionViewData.Transaction) {
        self.transaction = transaction
    }
    
    public var body: some View {
        VStack(spacing: 5) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    RefdsText(transaction.categoryName, size: .custom(10), color: transaction.categoryColor, weight: .black)
                    RefdsText(transaction.amount.currency, size: .extraLarge, weight: .bold, alignment: .leading, lineLimit: 1)
                }
                Spacer()
                RefdsText(transaction.date.asString(withDateFormat: .custom("HH:mm")))
            }
            HStack {
                RefdsText(transaction.description, color: .secondary)
                Spacer()
            }
        }
    }
}

struct TransactionCardView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ForEach(0...10, id: \.self) { index in
                TransactionCardView(transaction: .init(id: .init(), date: .current, description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", categoryName: "Lorem Ipsum", categoryColor: .random, amount: .random(in: 0...900)))
            }
        }
    }
}
