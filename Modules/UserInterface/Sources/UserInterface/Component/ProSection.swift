//
//  ProSection.swift
//  
//
//  Created by Rafael Santos on 20/04/23.
//

import SwiftUI
import RefdsUI
import Presentation
import Resource

public struct ProSection: View {
    @State private var isPresentedPro: Bool = false
    
    public var body: some View {
        if Device.current == .macOS {
            sectionmacOS
                .navigation(isPresented: $isPresentedPro) {
                    ProScreen<ProPresenter>(presenter: .shared)
                }
        } else {
            sectioniOS
                .sheet(isPresented: $isPresentedPro) {
                    ProScreen<ProPresenter>(presenter: .shared)
                }
        }
    }
    
    private var sectioniOS: some View {
        Section { rowPro }
    }
    
    private var sectionmacOS: some View {
        GroupBox { rowPro }.listGroupBoxStyle()
    }
    
    private var rowPro: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 15) {
                AppIconView(icon: .dollarsignSquareFill, color: .accentColor)
                    .scaledToFit()
                    .frame(height: 75)
                    .cornerRadius(10)
                RefdsText("Desbloqueie todas as funcionalidades sendo um usuário PRO!", weight: .bold)
            }
            RefdsText("Descubra todas as possibilidades que a nossa plataforma tem a oferecer!\n\nAproveite os recursos exclusivos disponíveis para usuários PRO, como acesso ilimitado a conteúdo premium, funcionalidades avançadas.\n\nSeja um usuário PRO agora e desfrute de uma experiência completa em nossa plataforma.", color: .secondary)
            
            Button { isPresentedPro.toggle() } label: {
                RefdsText("QUERO SER PRO", style: .footnote, color: .white, weight: .bold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.accentColor)
            .cornerRadius(8)
        }
        .padding()
    }
}
