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
                        restorePurchaseButton
                        buyProButton
                        termsButton
                        Spacer()
                    }
                    .padding()
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
            .frame(minHeight: 80)
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
    
    private var restorePurchaseButton: some View {
        Button {
            Task { try? await presenter.restore() }
        } label: {
            RefdsText("Restaurar Compra".uppercased(), size: .small, color: .accentColor, weight: .bold)
                .frame(maxWidth: .infinity)
        }
    }
    
    private var buyProButton: some View {
        Button {
            Task { try? await presenter.buyPro() }
        } label: {
            Group {
                RefdsText(presenter.string(.beProButton(4.99.currency)), size: .large, color: .white, weight: .bold)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color.accentColor.opacity(presenter.isAcceptedTerms ? 1 : 0.2))
            .cornerRadius(8)
        }
    }
    
    private var termsButton: some View {
        Button { UIApplication.shared.open(AboutLinks.policy.url) } label: {
            RefdsText(presenter.string(.readTermsButton), size: .small, color: .accentColor, alignment: .center)
        }
    }
}

