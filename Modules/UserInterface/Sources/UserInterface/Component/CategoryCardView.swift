//
//  CategoryCardView.swift
//  
//
//  Created by Rafael Santos on 07/06/23.
//

import SwiftUI
import RefdsUI
import Presentation

public struct CategoryCardView: View {
    private var category: CategoryViewData.Budget
    private let placeHolderPercent: String
    private let placeHolderAmountTransactions: String
    
    public init(category: CategoryViewData.Budget, placeHolderPercent: String, placeHolderAmountTransactions: String) {
        self.category = category
        self.placeHolderPercent = placeHolderPercent
        self.placeHolderAmountTransactions = placeHolderAmountTransactions
    }
    
    public var body: some View {
        HStack(spacing: 15) {
            RefdsIcon(symbol: category.icon, color: category.color, size: 15, weight: .medium, renderingMode: .hierarchical)
                .frame(width: 20, height: 20)
                .padding(.all, 5)
                .background(category.color.opacity(0.2))
                .cornerRadius(8)
            VStack(spacing: 2) {
                HStack {
                    RefdsText(category.name.capitalized, weight: .bold)
                    Spacer()
                    RefdsText(
                        category.budget.currency,
                        lineLimit: 1
                    )
                }
                
                HStack {
                    RefdsText(placeHolderPercent, color: .secondary)
                    Spacer()
                    RefdsText(placeHolderAmountTransactions, color: .secondary)
                }
            }
        }
    }
}
