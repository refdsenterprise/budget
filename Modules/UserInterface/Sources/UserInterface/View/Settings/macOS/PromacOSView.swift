//
//  PromacOSView.swift
//  
//
//  Created by Rafael Santos on 18/04/23.
//

import SwiftUI
import RefdsUI
import Presentation
import Resource

struct PromacOSView<Presenter: ProPresenterProtocol>: View {
    @Environment(\.dismiss) public var dismiss
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        MacUIView(sections: [
            .init(maxAmount: 1, content: {
                sectionBenefitsDescription
            }),
            .init(content: {
                sectionBenefits
            }),
            .init(maxAmount: 2, content: {
                Group {
                    SectionGroup {
                        Group {
                            sectionAcceptedTerms
                            sectionAppleInPurchaseDescription
                        }
                    }
                    VStack(alignment: .center, spacing: 15) {
                        buyProButton
                            .opacity(presenter.isAcceptedTerms ? 1 : 0.2)
                        termsButton
                    }
                }
            })
        ])
        .navigationTitle(presenter.string(.navigationTitle))
        .budgetAlert($presenter.acceptedAlert)
    }
    
    private func benefitPRO(title: Strings.Pro, description: Strings.Pro) -> some View {
        GroupBox {
            HStack {
                RefdsIcon(symbol: .checkmarkSealFill, renderingMode: .hierarchical)
                VStack(alignment: .leading) {
                    RefdsText(presenter.string(title))
                    RefdsText(presenter.string(description), color: .secondary)
                }
                Spacer()
            }
        }.listGroupBoxStyle()
    }
    
    private var sectionBenefitsDescription: some View {
        HStack {
            RefdsText(presenter.string(.benefitsDescription), color: .secondary)
            Spacer()
        }
    }
    
    private var sectionBenefits: some View  {
        Group {
            benefitPRO(title: .remaningTitle, description: .remaningDescription)
            benefitPRO(title: .chartsTitle, description: .chartsDescription)
            benefitPRO(title: .maxTransactionTitle, description: .maxTransactionDescription)
            benefitPRO(title: .weekDayTitle, description: .weekDayDescription)
            benefitPRO(title: .filterTitle, description: .filterDescription)
            benefitPRO(title: .categoryTitle, description: .categoryDescription)
            benefitPRO(title: .macOSTitle, description: .macOSDescription)
            benefitPRO(title: .notificationTitle, description: .notificationDescription)
            benefitPRO(title: .customizationTitle, description: .customizationDescription)
        }
    }
    
    private var sectionAcceptedTerms: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $presenter.isAcceptedTerms) {
                RefdsText(presenter.string(.acceptedTerms))
            }
            .toggleStyle(CheckBoxStyle(isLeading: true))
        }
    }
    
    private var sectionAppleInPurchaseDescription: some View  {
        RefdsText(presenter.string(.appleInPurchaseDescription), size: .small, color: .secondary, weight: .light)
    }
    
    private var buyProButton: some View {
        Button {
            presenter.buyPro(onSuccess: nil, onError: { presenter.acceptedAlert = .init(error: $0) })
        } label: {
            Group {
                RefdsText(presenter.string(.beProButton(4.99.currency)), size: .large, color: .white, weight: .bold)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color.accentColor)
            .cornerRadius(8)
        }
        .padding([.top, .leading, .trailing], 30)
    }
    
    private var termsButton: some View {
        Button { } label: {
            RefdsText(presenter.string(.readTermsButton), size: .small, color: .accentColor, alignment: .center)
        }
        .padding([.leading, .trailing, .bottom], 30)
        .padding(.bottom, 10)
    }
}

