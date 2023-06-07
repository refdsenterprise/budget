//
//  ProiOSView.swift
//  
//
//  Created by Rafael Santos on 28/03/23.
//

import SwiftUI
import RefdsUI
import Presentation
import Resource
#if os(iOS)
struct ProiOSView<Presenter: ProPresenterProtocol>: View {
    @Environment(\.colorScheme) public var colorScheme
    @Environment(\.dismiss) public var dismiss
    @EnvironmentObject private var presenter: Presenter
    
    var body: some View {
        NavigationView {
            List { 
                sectionBenefitsDescription
                sectionReport
                sectionResources
                sectionAcceptedTerms
                sectionAppleInPurchaseDescription
            }
            .navigationTitle(presenter.string(.navigationTitle))
            .budgetAlert($presenter.acceptedAlert)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { dismissButton } }
            .overlay(alignment: .bottom) {
                VStack {
                    VStack(alignment: .center, spacing: 15) {
                        buyProButton
                        termsButton
                    }
                    .padding(.all, 25)
                    .padding(.bottom)
                }
                .background(colorScheme == .dark ? Color(uiColor: .secondarySystemBackground) : .white)
                .cornerRadius(20)
                .padding(.bottom, 0)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
    private func benefitPRO(title: Strings.Pro, description: Strings.Pro) -> some View {
        HStack {
            RefdsIcon(symbol: .checkmarkSealFill, renderingMode: .hierarchical)
            VStack(alignment: .leading) {
                RefdsText(presenter.string(title))
                RefdsText(presenter.string(description), color: .secondary)
            }
        }
    }
    
    private var sectionBenefitsDescription: some View {
        Section {} footer: {
            RefdsText(presenter.string(.benefitsDescription), color: .secondary)
        }
    }
    
    private var sectionReport: some View  {
        Section {
            benefitPRO(title: .remaningTitle, description: .remaningDescription)
            benefitPRO(title: .chartsTitle, description: .chartsDescription)
            benefitPRO(title: .maxTransactionTitle, description: .maxTransactionDescription)
            benefitPRO(title: .weekDayTitle, description: .weekDayDescription)
        } header: {
            RefdsText(presenter.string(.reportHeader), style: .caption1, color: .secondary)
        }
    }
    
    private var sectionResources: some View {
        Section {
            benefitPRO(title: .filterTitle, description: .filterDescription)
            benefitPRO(title: .categoryTitle, description: .categoryDescription)
            benefitPRO(title: .macOSTitle, description: .macOSDescription)
            benefitPRO(title: .notificationTitle, description: .notificationDescription)
            benefitPRO(title: .customizationTitle, description: .customizationDescription)
        } header: {
            RefdsText(presenter.string(.resourceHeader), style: .caption1, color: .secondary)
        }
    }
    
    private var sectionAcceptedTerms: some View {
        Section {} footer: {
            VStack(alignment: .leading) {
                RefdsToggle(isOn: $presenter.isAcceptedTerms) {
                    RefdsText(presenter.string(.acceptedTerms))
                }
            }
            .padding(.top, -20)
        }
    }
    
    private var sectionAppleInPurchaseDescription: some View  {
        Section {} footer: {
            VStack(alignment: .leading, spacing: 30) {
                RefdsText(presenter.string(.appleInPurchaseDescription), style: .caption1, color: .secondary, weight: .light)
                restorePurchaseButton
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 180)
            .padding(.top, -20)
        }
    }
    
    private var dismissButton: some View {
        Button { dismiss() } label: {
            RefdsIcon(symbol: .xmarkCircleFill, color: .secondary, size: 20, renderingMode: .hierarchical)
        }
    }
    
    private var restorePurchaseButton: some View {
        Button {
            Task { try? await presenter.restore() }
        } label: {
            Group {
                RefdsText("Restaurar Compra".uppercased(), style: .footnote, color: .accentColor, weight: .bold)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color(uiColor: colorScheme == .dark ? .secondarySystemBackground : .systemBackground))
            .cornerRadius(8)
        }
    }
    
    private var buyProButton: some View {
        Button {
            Task { try? await presenter.buyPro() }
        } label: {
            Group {
                RefdsText(presenter.string(.beProButton(4.99.currency)), style: .body, color: presenter.isAcceptedTerms ? .white : .secondary, weight: .bold)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color.accentColor.opacity(presenter.isAcceptedTerms ? 1 : 0.2))
            .cornerRadius(8)
        }
    }
    
    private var termsButton: some View {
        Button { UIApplication.shared.open(AboutLinks.policy.url) } label: {
            RefdsText(presenter.string(.readTermsButton), style: .footnote, color: .accentColor, alignment: .center)
        }
    }
}
#endif
