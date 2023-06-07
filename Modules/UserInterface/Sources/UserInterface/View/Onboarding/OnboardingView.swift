//
//  OnboardingView.swift
//
//
//  Created by Rafael Santos on 18/03/23.
//

import SwiftUI
import RefdsUI
import Resource

public struct OnboardingView: View {
    @AppStorage(.refdsString(.storage(.onboarding))) private var onboarding: Bool = false
    @Binding private var isFinished: Bool
    @State private var selectionTab: Int = 0
    
    public init(isFinished: Binding<Bool>) {
        self._isFinished = isFinished
    }
    
    public var body: some View {
        VStack {
            TabView(selection: $selectionTab) {
                OnboardingCardView(
                    .category,
                    title: Strings.Onboarding.categoryTitle.value,
                    description: Strings.Onboarding.categoryDescription.value,
                    keywords: Strings.Onboarding.categoryKeywords.value.components(separatedBy: ",")
                )
                .tag(0)
                
                OnboardingCardView(
                    .budget,
                    title: Strings.Onboarding.budgetTitle.value,
                    description: Strings.Onboarding.budgetDescription.value,
                    keywords: Strings.Onboarding.budgetKeywords.value.components(separatedBy: ",")
                )
                .tag(1)
                
                OnboardingCardView(
                    .transaction,
                    title: Strings.Onboarding.transactionTitle.value,
                    description: Strings.Onboarding.transactionDescription.value,
                    keywords: Strings.Onboarding.transactionKeywords.value.components(separatedBy: ",")
                )
                .tag(2)
            }
            #if os(iOS)
            .tabViewStyle(.page(indexDisplayMode: .never))
            #endif
            
            buttonPageControl
                .padding()
                .padding(.horizontal)
                .frame(maxWidth: 500)
        }
    }
    
    @ViewBuilder
    private var buttonPageControl: some View {
        HStack {
            if selectionTab == 0 {
                Spacer()
                RefdsButton(Strings.Onboarding.next.value, color: .accentColor, style: .primary, maxSize: true) {
                    withAnimation { selectionTab += 1 }
                }
            } else if selectionTab == 2 {
                RefdsButton(Strings.Onboarding.previous.value, color: .accentColor, style: .secondary, maxSize: true) {
                    withAnimation { selectionTab -= 1 }
                }
                RefdsButton(Strings.Onboarding.getStart.value, color: .accentColor, style: .primary, maxSize: true) {
                    withAnimation { isFinished.toggle() }
                }
            } else if selectionTab == 1 {
                RefdsButton(Strings.Onboarding.previous.value, color: .accentColor, style: .secondary, maxSize: true) {
                    withAnimation { selectionTab -= 1 }
                }
                RefdsButton(Strings.Onboarding.next.value, color: .accentColor, style: .primary, maxSize: true) {
                    withAnimation { selectionTab += 1 }
                }
            }
        }
    }
}

struct OnboardingViewModifier: ViewModifier {
    @Binding var isFinished: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                ZStack {
                    if !isFinished {
                        OnboardingView(isFinished: $isFinished)
                            .background(ignoresSafeAreaEdges: .all)
                    }
                }.animation(.spring(), value: isFinished)
            }
    }
}

public extension View {
    func onboardingView(isFinished: Binding<Bool>) -> some View {
        self.modifier(OnboardingViewModifier(isFinished: isFinished))
    }
}
