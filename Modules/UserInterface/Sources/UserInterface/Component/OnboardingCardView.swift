//
//  OnboardingCardView.swift
//  
//
//  Created by Rafael Santos on 06/06/23.
//

import SwiftUI
import RefdsUI
import Resource
import Presentation

public struct OnboardingCardView: View {
    @State private var motionScaleFactor: Int = 0
    @State private var stopAnimation: Bool = false
    @State private var bubbles: [BudgetViewData.Bubble] = []
    private var icon: RefdsIconSymbol {
        [.cameraFill, .phoneFill, .videoFill, .envelope, .bagFill, .cartFill].randomElement() ?? .dollarsign
    }
    private var color: RefdsColor {
        [.pink, .red, .orange, .green, .blue, .indigo, .teal].randomElement() ?? .random
    }
    
    private let tab: Tab
    private let title: String
    private let description: String
    private let keywords: [String]
    
    public init(_ tab: Tab, title: String, description: String, keywords: [String]) {
        self.tab = tab
        self.title = title
        self.description = description
        self.keywords = keywords
        self.bubbles = Array(0...5).map({ _ in
            let value = Double.random(in: 300...500)
            return BudgetViewData.Bubble(id: .init(), title: value.currency, value: value, color: color, realValue: value)
        })
    }
    
    private func startAnimation() {
        if !stopAnimation {
            withAnimation {
                switch tab {
                case .category:
                    motionScaleFactor = motionScaleFactor == 3 ? -1 : motionScaleFactor
                    motionScaleFactor += 1
                case .budget:
                    bubbles = Array(0...5).map({ _ in
                        let value = Double.random(in: 300...500)
                        return BudgetViewData.Bubble(id: .init(), title: value.currency, value: value, color: color, realValue: value)
                    })
                case .transaction:
                    motionScaleFactor = motionScaleFactor == 2 ? -1 : motionScaleFactor
                    motionScaleFactor += 1
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (tab == .budget ? 4 : 1.5)) {
                startAnimation()
            }
        }
    }
    
    public var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 20) {
                        switch tab {
                        case .category: categoriesExampleView
                        case .budget: bugetExampleView
                        case .transaction: transactionExampleView
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        RefdsText(title, style: .largeTitle, color: .primary, weight: .bold)
                        Spacer()
                    }
                    
                    HStack {
                        RefdsText(keywords.joined(separator: " •").uppercased(), style: .caption2, color: .primary, weight: .bold)
                        Spacer()
                    }
                    
                    HStack {
                        RefdsText(description, style: .subheadline, color: .secondary)
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: 500, maxHeight: 1000)
        .onAppear {
            stopAnimation = false
            startAnimation()
        }
        .onDisappear { stopAnimation = true }
    }
    
    private var categoriesExampleView: some View {
        VStack {
            Spacer()
            ForEach(0...3, id: \.self) { index in
                CategoryCardView(
                    category: .init(
                        id: .init(),
                        color: color,
                        name: Strings.Onboarding.category.value, percent: "30%",
                        amountTransactions: 6,
                        budget: Double.random(in: 2000...4000),
                        date: .current, icon: icon
                    ),
                    placeHolderPercent: "\(Int.random(in: 1...100))%",
                    placeHolderAmountTransactions: "\(Int.random(in: 3...20)) \(Strings.Onboarding.transactions.value)"
                )
                .redacted(reason: motionScaleFactor != index ? .placeholder : [])
                .refdsCard()
                .scaleEffect(motionScaleFactor != index ? 1 : 1.1)
            }
            Spacer()
        }
        .padding()
        .padding(.bottom)
    }
    
    private var bugetExampleView: some View {
        VStack {
            Spacer()
            BubbleView(viewData: $bubbles)
                .frame(height: 300)
            Spacer()
        }
        .padding()
        .padding(.bottom)
    }
    
    private var transactionExampleView: some View {
        VStack {
            Spacer()
            ForEach(0...2, id: \.self) { index in
                TransactionCardView(
                    transaction: .init(
                        id: .init(),
                        date: .current,
                        description: Strings.Onboarding.transactionDescriptionPlaceholder.value,
                        categoryName: Strings.Onboarding.category.value,
                        categoryColor: color,
                        amount: Double.random(in: 50...300), categoryIcon: icon
                    )
                )
                .redacted(reason: motionScaleFactor != index ? .placeholder : [])
                .refdsCard()
                .scaleEffect(motionScaleFactor != index ? 1 : 1.1)
            }
            Spacer()
        }
        .padding()
        .padding(.bottom)
    }
}

public extension OnboardingCardView {
    enum Tab {
        case category
        case budget
        case transaction
    }
}

struct OnboardingCardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCardView(
            .category,
            title: Strings.Onboarding.categoryTitle.value,
            description: Strings.Onboarding.categoryDescription.value,
            keywords: Strings.Onboarding.categoryKeywords.value.components(separatedBy: ",")
        )
        
        OnboardingCardView(
            .budget,
            title: Strings.Onboarding.budgetTitle.value,
            description: Strings.Onboarding.budgetDescription.value,
            keywords: Strings.Onboarding.budgetKeywords.value.components(separatedBy: ",")
        )
        
        OnboardingCardView(
            .transaction,
            title: Strings.Onboarding.transactionTitle.value,
            description: Strings.Onboarding.transactionDescription.value,
            keywords: Strings.Onboarding.transactionKeywords.value.components(separatedBy: ",")
        )
    }
}
